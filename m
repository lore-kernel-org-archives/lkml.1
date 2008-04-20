Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbYDTW7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbYDTW7S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 18:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbYDTW7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 18:59:06 -0400
Received: from ozlabs.org ([203.10.76.45]:56376 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbYDTW7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 18:59:05 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] typesafe callbacks
Date: Mon, 21 Apr 2008 08:58:59 +1000
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804210859.00080.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idea is to create a general typesafe callback mechanism which doesn't 
break compile on existing code and doesn't allow any unsafe callback types.

Al had a very long timer conversion series followed by a different mechanism, 
and that just covered timers; unfortunately that technique provides 
insufficient typechecking for the general case (eg. int return types and 
callback functions which take integer args as well as the data arg).

Note that these typechecks end up being *too* strict in some cases, 
disallowing some potentially valid cases.  But since you can still use the 
current via-void* method, these corner cases lose nothing.

