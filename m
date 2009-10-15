Return-Path: <linux-kernel-owner+w=401wt.eu-S1762863AbZJOPsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762863AbZJOPsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 11:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762854AbZJOPsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 11:48:10 -0400
Received: from fifo99.com ([67.223.236.141]:59689 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762851AbZJOPsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 11:48:09 -0400
Subject: Re: Tips for module_init() dependencies
From: Daniel Walker <dwalker@fifo99.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4AD71D12.9060203@gmail.com>
References: <4AD71D12.9060203@gmail.com>
Content-Type: text/plain
Date: Thu, 15 Oct 2009 08:45:59 -0700
Message-Id: <1255621559.22917.35.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-15 at 09:01 -0400, Gregory Haskins wrote:

> may break, because the kernel seems to have no concept of
> interdependency between foo_init() and bar_init(), and therefore
> bar_init() may call foo() before foo_init() has executed.
> 
> There are various ways to solve this problem, such as deferring calling
> foo() with a workqueue or something, but I was wondering if there was a
> better/standard way to do this that I am missing?
> 
> The problem I am having specifically is that I am trying to call
> configfs_register_subsystem() in a module_init(), but this breaks when
> built into the kernel based on sheer bad luck that configfs gets
> initialized after me.  To date I have worked around this by forcing my
> code to only support built-in, and using late_initcall() instead or
> module_init.  This works, but it only means I am putting the problem off
> (code that depends on *me* has to use similar tricks, etc.

You can't modify the build order so your module get "builtin" after
configfs?

Daniel 

