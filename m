Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbXJXLur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbXJXLur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 07:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756099AbXJXLui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 07:50:38 -0400
Received: from narury.org ([84.16.240.217]:41783 "EHLO narury.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756003AbXJXLuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 07:50:37 -0400
Date: Wed, 24 Oct 2007 14:50:34 +0300
From: Riku Voipio <riku.voipio@iki.fi>
To: Jean Delvare <khali@linux-fr.org>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] hwmon/f75375s.c: buggy if()
Message-ID: <20071024115034.GA5797@kos.to>
References: <20071017195439.GD3778@stusta.de> <20071017204508.GA32110@kos.to> <20071018133744.GC3526@jupiter.solarsys.private> <20071019143754.0aa4483b@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071019143754.0aa4483b@hyperion.delvare>
X-message-flag: Warning: message not sent with a DRM-Certified client
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2007 at 02:37:54PM +0200, Jean Delvare wrote:
> Riku, can you please submit a patch fixing this? The attribute should
> be declared read-only, and then you can use sysfs_chmod_file() to
> change it to read-write where supported. 

Thanks, this was good suggestion. Patch attached.

> Take a look at the w83781d
> driver for an example.

Btw, I think your example code has a indentation bug:

		if (kind != w83781d)
			err = sysfs_chmod_file(&dev->kobj,
				&sensor_dev_attr_temp3_alarm.dev_attr.attr,
				S_IRUGO | S_IWUSR);
			if (err)
				return err;

-- 
"rm -rf" only sounds scary if you don't have backups
