Return-Path: <linux-kernel-owner+w=401wt.eu-S1753686AbYKSNxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbYKSNxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 08:53:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbYKSNw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 08:52:59 -0500
Received: from styx.suse.cz ([82.119.242.94]:42793 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752293AbYKSNw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 08:52:59 -0500
Date: Wed, 19 Nov 2008 14:52:57 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Rafi Rubin <rafi@seas.upenn.edu>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] n-trig digitizer quirks
In-Reply-To: <492417D4.4090103@seas.upenn.edu>
Message-ID: <alpine.LNX.1.10.0811191451000.19853@jikos.suse.cz>
References: <Pine.LNX.4.61.0811141207210.12963@minus.seas.upenn.edu> <alpine.LNX.1.10.0811181525490.19853@jikos.suse.cz> <49232910.2030309@seas.upenn.edu> <alpine.LNX.1.10.0811191355280.19853@jikos.suse.cz> <492417D4.4090103@seas.upenn.edu>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2008, Rafi Rubin wrote:

> >> +static int ntrig_input_mapped(struct hid_device *hdev, struct hid_input *hi,
> >> +		struct hid_field *field, struct hid_usage *usage,
> >> +		unsigned long **bit, int *max)
> >> +{
> >> +	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
> > This could be removed, as it is never used, right?
> Yes, it wasn't used at the moment, just something left over from using 
> hid-lg.c as a template.  Since this is the only device known for this 
> driver at this point, is it better to keep it shorter and not check for 
> the duplicate usage from the driver data or would it be better to add 
> the flexibility now?  

Please keep the driver as simple as possible. Whenever there are any new 
devices in the future, we could easily extend it so that quirk data in 
driver_data are taken into account.

> Also, if you do prefer using driver data like that, is the probe 
> function necessary to make it work?

Probe function is necesary, you need to parse the report descriptor 
(hid_parse()), activate the hardware (hid_hw_start()), etc.

Thanks,

-- 
Jiri Kosina
SUSE Labs
