Return-Path: <linux-kernel-owner+w=401wt.eu-S1757872AbYGaSyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872AbYGaSyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 14:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbYGaSxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 14:53:40 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:56733 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311AbYGaSxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 14:53:38 -0400
Message-ID: <48920AC1.3040506@keyaccess.nl>
Date: Thu, 31 Jul 2008 20:56:01 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Simon Arlott <simon@fire.lp0.eu>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Daniel Walker <dwalker@mvista.com>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [patch 5/3] fastboot: sync the async execution before      late_initcall
 and move level 6s (sync) first
References: <Pine.LNX.4.44L0.0807311110300.4409-100000@iolanthe.rowland.org> <48920481.7010702@simon.arlott.org.uk>
In-Reply-To: <48920481.7010702@simon.arlott.org.uk>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -0.3 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31-07-08 20:29, Simon Arlott wrote:

> Ok - so there could be some big improvements to be had by making the hcd 
> init happen as early as possible and the device initcalls later?

Arjan also needed a pre device_initcall() level for PCI core init now 
that the async device initcalls weren't governed just by link order 
anymore. He reused the device_initcall_sync() level, moving it to before 
device_initcall() itself (it used to be just behind).

Your above notion sounds like another good reason for inserting a real 
new level just before device_initcall(); if you move any of the device 
init to late initcall(), late_initcall() loses too much of its utility 
I'd feel (see start of this thread with various late_initcalls wanting 
to assume stuff).

Rene.
