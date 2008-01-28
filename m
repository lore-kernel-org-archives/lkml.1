Return-Path: <linux-kernel-owner+w=401wt.eu-S1760636AbYA1N5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636AbYA1N5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 08:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbYA1N5C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 08:57:02 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:64803 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751730AbYA1N5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 08:57:00 -0500
Date: Mon, 28 Jan 2008 14:56:15 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: michael <trimarchi@gandalf.sssup.it>
Cc: linux-kernel@vger.kernel.org, Andrew Victor <linux@maxim.org.za>,
       David Brownell <david-b@pacbell.net>
Subject: Re: at91sam9260 wakeup on serial port
Message-ID: <20080128145615.1d756025@dhcp-252-066.norway.atmel.com>
In-Reply-To: <479DB934.6090806@gandalf.sssup.it>
References: <479DB934.6090806@gandalf.sssup.it>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 12:15:00 +0100
michael <trimarchi@gandalf.sssup.it> wrote:

> Hi,
> I implement a little patch (ndr just for a try) for the atmel serial 
> driver atmel_serial.c to wakeup the system when it is in suspend-ram state.
> I reconfigure the RXD pin as a gpio in suspend function and restore it 
> in the resume function. It is the correct way?

I'm not sure...this is rather platform-specific, so I don't think it
really belongs in the atmel_serial() driver. One solution might be to
add a function pointer to struct atmel_uart_data that the driver can
call from ->suspend() in order to let the platform code handle this as
appropriate.

Cc'ing Andrew Victor and David Brownell since they know the AT91
platform code better than me.

Haavard
