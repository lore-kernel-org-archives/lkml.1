Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab0BYEUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 23:20:14 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:40651 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249Ab0BYEUL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 23:20:11 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Bruno =?utf-8?q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Subject: Re: [PATCH 2/3] hid: add suspend/resume hooks for hid drivers
Date: Thu, 25 Feb 2010 05:19:46 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc8-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>
References: <20100221002001.0a7e05a7@neptune.home> <20100224163101.3622d69f@neptune.home> <20100224170112.576403ee@neptune.home>
In-Reply-To: <20100224170112.576403ee@neptune.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002250519.46496.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 24. Februar 2010 17:01:12 schrieb Bruno Prémont:
> Add suspend/resume hooks for HID drivers so these can do some
> additional state adjustment when device gets suspended/resumed.
> 
> This patch calls these hooks from usbhid suspend/resume functions,
> only calling suspend on plain suspend, not autosuspend.
> (it might be worth adding an autosuspend parameter to suspend
> hook and calling suspend in both cases)

This is quite dirty. A driver that was autosuspended may be non-auto resumed.
Secondly, do you really want to call the hook for reset_resume() if
hid_post_reset() has failed?

	Regards
		Oliver
