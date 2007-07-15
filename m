Return-Path: <linux-kernel-owner+w=401wt.eu-S1760483AbXGOXSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760483AbXGOXSg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760150AbXGOXSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:18:15 -0400
Received: from smtp108.sbc.mail.mud.yahoo.com ([68.142.198.207]:34877 "HELO
	smtp108.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758173AbXGOXSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:18:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=WaZCPmAo8W3OFY7QIVsAMpM9z82xdFHnDo/5JzG37m84Ta80DkElvXxF5mg+C0MklWnrqkyc82ZIU0K6B8N8NThKJHcjy4reCSR4MKSFrONm9PKbH+mD9sKavRv4gFxKsuuwxCoh9JwJWaMy2QnAmZJ58qROtuBhEgwCWJB5fds=  ;
X-YMail-OSG: _1lyWA0VM1l8DmlrYkYlGK9iw1qR73ngzvCfgr7dAEtS5OSuVMRwO5K75gFqTxldrfvHtEqzcQ--
From: David Brownell <david-b@pacbell.net>
To: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] minimal fixes for drivers/usb/gadget/m66592-udc.c
Date: Sun, 15 Jul 2007 16:18:10 -0700
User-Agent: KMail/1.9.6
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>
References: <200707151607.20275.david-b@pacbell.net>
In-Reply-To: <200707151607.20275.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707151618.10688.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Re the leaks, in probe() request_irq() isn't cleaned up ... but it
looked to me like the rest of the allocations did get cleaned up
afer probe() errors.  But remove() does indeed leak the memory you
highlighted.

