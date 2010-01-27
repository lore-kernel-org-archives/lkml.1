Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517Ab0A0S3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab0A0S3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 13:29:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506Ab0A0S3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 13:29:07 -0500
Received: from lo.gmane.org ([80.91.229.12]:40815 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258Ab0A0S3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 13:29:07 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Russ Dill <Russ.Dill@gmail.com>
Subject: Re: How to write driver that needs to call another driver?
Date: Wed, 27 Jan 2010 18:28:30 +0000 (UTC)
Message-ID: <loom.20100127T192218-294@post.gmane.org>
References: <1264540265.2411.20.camel@utx.utx.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 65.121.28.16 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.5) Gecko/20091102 Firefox/3.5.5)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislav Brabec <utx <at> penguin.cz> writes:

>
> My Zaurus SL-C3200 PDA needs a driver that needs to call another driver
> from another part of the device tree:
>
> MAX1111 (4 channel A/D) is connected to several other pieces of hardware
> (audio player remote keyboard, battery voltage, battery temperature,
> external power voltage).
>
> Battery power and charging management needs to read values from MAX1111
> during. Also Remote Keyboard input device needs to read MAX1111.
>
> But both drivers also need dedicated GPIO that are allocated on Scoop
> chip (different part of the platform device tree).
>

GPIO already has a generic API that can be used. I've had similar problems with
I2C devices. I've always implemented as adding in .command support to the I2C
driver in question, using i2c_use_client and then try_module_get. I'm not sure
if it is the proper way of doing things, it's always bugged me that there
doesn't seem to programatically access things like I2C eeproms and HW monitoring
devices. They seem to only be exposed though sysfs.

