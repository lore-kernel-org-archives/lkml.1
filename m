Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab0BAXB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 18:01:58 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:54030 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab0BAXB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 18:01:56 -0500
Date: Mon, 1 Feb 2010 23:01:53 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Bob Rodgers <Robert_Rodgers@dell.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
       Michael E Brown <Michael_E_Brown@dell.com>,
       Matt Domsch <Matt_Domsch@dell.com>,
       Mario Limonciello <Mario_Limonciello@dell.com>,
       Louis Davis <Louis_Davis@dell.com>, Jim Dailey <Jim_Dailey@dell.com>
Subject: Re: [RFC] Dell activity led WMI driver
Message-ID: <20100201230153.GD15766@srcf.ucam.org>
References: <4B675954.6000406@dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B675954.6000406@dell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 04:44:36PM -0600, Bob Rodgers wrote:

> This has been internally reviewed, and we are ready for outside review  
> and feedback. My colleagues have identified the dell-wmi module as a  
> suitable container in lieu of a stand-alone module specifically for this  
> driver, which makes sense, but we welcome advice. We are submitting it  
> as a stand-alone module for now because that is how we developed and  
> tested it. We would like this to be included upstream after it has been  
> reviewed.

It uses a different GUID to the event interface used by dell-wmi, so 
right now there's no inherent reason to integrate it into that rather 
than keeping it as a separate driver. On the other hand, if the GUID is 
useful for other kinds of system control rather than just the LED then 
dell-wmi may want to make use of that functionality in the future. In 
that case we'd need it to be incorporated into the dell-wmi driver.

So, really, it depends on the interface. If this GUID is specific to 
LEDs, then keep it separate. Otherwise it should be integrated.

I've got a few comments on the code...

> // Error Result Codes:

C99 style comments are usually discouraged in the kernel. 

> // Devide ID

Typo?

> // LED Commands
> #define CMD_LED_ON		16
> #define CMD_LED_OFF		17
> #define CMD_LED_BLINK	18

Use of whitespace isn't very consistent here.

> struct bios_args {
> 	unsigned char Length;
> 	unsigned char ResultCode;
> 	unsigned char DeviceId;
> 	unsigned char Command;
> 	unsigned char OnTime;
> 	unsigned char OffTime;
> 	unsigned char Reserved[122];
> };

Mm. We're also not usually big on CamelCasing in variable names - it'd 
be preferable to use underscores. That's true for the rest of this, too.

> 	// free the output ACPI object allocated by ACPI driver

Probably don't need this comment.

> static void led_on(void)
> {
> 	dell_led_perform_fn(3,		// Length of command
> 		INTERFACE_ERROR,		// Init result code to 	INTERFACE_ERROR
> 		DEVICE_ID_PANEL_BACK,	// Device ID
> 		CMD_LED_ON,				// Command
> 		0,						// not used
> 		0);						// not used
> }

Whitespace is a bit odd here, again.

Other than that, it looks good. You probably want to run it through 
Scripts/checkpatch.pl in the kernel tree to perform further style 
checks, but I can't see any functional issues.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
