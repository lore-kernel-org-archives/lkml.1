Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbYJ0UDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbYJ0UDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 16:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYJ0UDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 16:03:25 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:39627 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752628AbYJ0UDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 16:03:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=O1zIeR1xJoYcmalW9/NVsKq34F0FJuLxLAtF81mHMlriAyu8g4wqBLCIr/7u1DcnUB1Pc30eHQ5EVzgB0WBHeX4LRpYFT/dGD4WUG+x+YSuridmyw4d0GlXq7MGw1dixVCkGX7dKKEydfhlYdLVnWmdfm2S4tBRiOQ4VwFmTzDI=  ;
X-YMail-OSG: C434A.gVM1nJz2EUe1SvdJDLxTq7pbGgslt6lfpDbrEuTQkFQoGjb06nYLc5frCq3s1B06ieVQYyskLae8V7qL8K9vVCpc1WtTVawquLWVh3H0VLV.UHnhIQuGnHMrmxBOS9tMT5qi1HD2dHbLc.Ly4B
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: [rtc-linux] [PATCH 2/2] rtc: rtc-wm8350: Add support for WM8350 RTC
Date: Mon, 27 Oct 2008 13:03:21 -0700
User-Agent: KMail/1.9.10
Cc: rtc-linux@googlegroups.com, broonie@opensource.wolfsonmicro.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1225121905-23782-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1225121905-23782-2-git-send-email-broonie@opensource.wolfsonmicro.com> <20081027180432.7deaee0a@i1501.lan.towertech.it>
In-Reply-To: <20081027180432.7deaee0a@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200810271303.21634.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 October 2008, Alessandro Zummo wrote:
>  (and a detailed checklist at http://groups.google.com/group/rtc-linux/web/checklist )

The comment about probe()/__devinit and remove()/__devexit/__devexit_p
isn't right ... when the driver uses platform_driver_probe(), the "__dev"
variants should not be used.  (It's a Good Thing to shrink runtime code
footprints, by using platform_driver_probe for non-hotpluggable devices.)

Also:  rtc_ops.ioctl() method should only handle RTC_{AIE,UIE}_{ON,OFF},
since the other standard ioctls have rtc_ops equivalents.


(This code is fine in both respects.  Though since I've received three
copies of the driver since it was merged to MM, maybe I missed something.)

- Dave
