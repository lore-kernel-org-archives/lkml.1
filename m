Return-Path: <linux-kernel-owner+w=401wt.eu-S1753223AbYJ1JSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbYJ1JSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 05:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYJ1JSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 05:18:43 -0400
Received: from burp.tkv.asdf.org ([212.16.99.49]:56046 "EHLO
	cs181073102.pp.htv.fi" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751527AbYJ1JSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 05:18:42 -0400
Date: Tue, 28 Oct 2008 11:18:38 +0200
From: Markku Savela <msa@moth.iki.fi>
Message-Id: <200810280918.m9S9Icre029090@burp.tkv.asdf.org>
To: linux-kernel@vger.kernel.org
Subject: Silly questions: how can those security_ops->foo(...) calls work when entries seem to be NULL?
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can someone point me to the explanation?

- the "register_security" just loads the pointer to "security_ops"

- most LSM modules only define subset of the function pointers, and as
  far as I can tell, the rest are NULL.

- however, all security calls just seem to call blindly
  "security_ops->foo(...)" without caring wether the function is NULL.

Just curious: how does this magic work?

Does same magic work for all "ops" tables in the kernel? Might get
size and speed reduction if need to test for the NULL function pointer
is removed -- at a huge cost of uncertainty, because all NULL pointer
function deferences would then go undetected.
