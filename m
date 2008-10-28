Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbYJ1Lrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbYJ1Lrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 07:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbYJ1Lro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 07:47:44 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:42602 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbYJ1Lrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 07:47:43 -0400
Date: Tue, 28 Oct 2008 12:45:26 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Andrew Victor <linux@maxim.org.za>
Subject: Re: [patch 2.6.28-rc2] atmel_serial: keep clock off when it's not
 needed
Message-ID: <20081028124526.6b9ccdf5@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <200810271406.24110.david-b@pacbell.net>
References: <200810271406.24110.david-b@pacbell.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 28 Oct 2008 11:45:07.0546 (UTC) FILETIME=[A010B3A0:01C938F2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell <david-b@pacbell.net> wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> The atmel_serial driver is mismanaging its clock by leaving it on
> at all times ... the whole point of clock management is to leave
> it off unless it's actively needed, which conserves power!!
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

Hmm...the only remaining clk_enable() is in atmel_serial_pm(). Is that
really enough?

It looks like the serial core calls ->pm() to power the port up before
doing anything that might touch the registers, but I can't see that the
console layer does the same thing...

Haavard
