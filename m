Return-Path: <linux-kernel-owner+w=401wt.eu-S1759246AbXLLLsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246AbXLLLsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 06:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757787AbXLLLsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 06:48:31 -0500
Received: from aun.it.uu.se ([130.238.12.36]:58523 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757072AbXLLLsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 06:48:30 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18271.51833.872482.880312@harpo.it.uu.se>
Date: Wed, 12 Dec 2007 12:48:09 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: acpi ->video_device_list corruption
In-Reply-To: <20071212101505.GA18472@holomorphy.com>
References: <20071212101505.GA18472@holomorphy.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III writes:
 > The ->cap fields of struct acpi_video_device and struct acpi_video_bus
 > are 1B each, not 4B. The oversized memset()'s corrupted the subsequent
 > list_head fields. This resulted in silent corruption without
 > CONFIG_DEBUG_LIST and BUG's with it. This patch uses sizeof() to pass
 > the proper bounds to the memset() calls and thereby correct the bugs.
 > 
 > Included as a MIME attachment is a compressed dmesg from an affected
 > system. The patch was seen to resolve the issue on the affected system.
 > 
 > vs. 2.6.24-rc5
 > 
 > Signed-off-by: William Irwin <wli@holomorphy.com>
 > 
 > 
 > -- wli
 > 
 > diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
 > index 44a0d9b..7895d57 100644
 > --- a/drivers/acpi/video.c
 > +++ b/drivers/acpi/video.c
 > @@ -577,7 +577,7 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
 >  	struct acpi_video_device_brightness *br = NULL;
 >  
 >  
 > -	memset(&device->cap, 0, 4);
 > +	memset(&device->cap, 0, sizeof(struct acpi_video_device_cap));

IMO the memset(ptr, 0, sizeof(*ptr)) idiom is both safer
and avoids having to write an uninteresting type name.
