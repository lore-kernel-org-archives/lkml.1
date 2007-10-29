Return-Path: <linux-kernel-owner+w=401wt.eu-S1758199AbXJ2OtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbXJ2OtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 10:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbXJ2OtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 10:49:10 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54101 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793AbXJ2OtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 10:49:09 -0400
Message-ID: <4725F2DF.1060500@garzik.org>
Date: Mon, 29 Oct 2007 10:49:03 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jiri Kosina <jikos@jikos.cz>, Dirk Hohndel <hohndel@linux.intel.com>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] INPUT: fix hidinput_connect ignoring retval from input_register_device
References: <20071029084917.GA12968@bigserver.hohndel.org>	 <Pine.LNX.4.64.0710291113450.18815@twin.jikos.cz> <d120d5000710290554x618eca05tbf864a0f7f9b77a5@mail.gmail.com>
In-Reply-To: <d120d5000710290554x618eca05tbf864a0f7f9b77a5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On 10/29/07, Jiri Kosina <jikos@jikos.cz> wrote:
>> On Mon, 29 Oct 2007, Dirk Hohndel wrote:
>>
>>> [INPUT] hidinput_connect incorrectly ignored return value from
>>> input_register_device
>>> Signed-off-by: Dirk Hohndel <hohndel@linux.intel.com>
>> Will apply
> 
> Please don't - the fix is completely broken for multi-input devices -
> if 2nd device fails to register we bail out of hidinput_connect and
> thus never set HID_CLAIMED_INPUT bit. So when we disconnect device we
> never call hidinput_disconnect and who knows what will happen after
> that.
> 
> hidinput_connect() should properly unwind already registered devices
> after failure.

Then the existing code to handle hidinput and input_dev allocation 
failure probably also wants fixing...  Dirk's patch was largely 
following the same logic.

	Jeff



