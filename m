Return-Path: <linux-kernel-owner+w=401wt.eu-S932260AbZLOOXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbZLOOXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 09:23:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760380AbZLOOXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 09:23:01 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:48790 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760360AbZLOOXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 09:23:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=N+k5YRLTvX0JyIP4wkkqlEpvJV1/18DEZCfT73wDterz5OEwc+ZckDU6yoaah9wzLZ
         0fDjUXMgWzXFnsWRubT34J274dWQzmKcl6UMPyLMJdaAOAbRdA/vI0N7BNuMlv5sfWNV
         rMOMBkElH9v402NP7vOACPSuuAvmFr1CDF0vI=
Date: Tue, 15 Dec 2009 16:23:03 +0200
From: Dan Carpenter <error27@gmail.com>
To: Steven King <sfking@fdwdc.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][input] add Honeywell hmc5843 3-Axis Magnetometer
	(digital compass)  driver.
Message-ID: <20091215142303.GC24799@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Steven King <sfking@fdwdc.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200912102250.12853.sfking@fdwdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200912102250.12853.sfking@fdwdc.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 10:50:12PM -0800, Steven King wrote:
> +static void hmc5843_poll(struct input_polled_dev *ipdev)
> +{
> +	struct hmc5843 *hmc5843 = ipdev->private;
> +	int x, y, z;
> +

  CC      drivers/input/misc/hmc5843.o
drivers/input/misc/hmc5843.c: In function ‘hmc5843_poll’:
drivers/input/misc/hmc5843.c:312: warning: ‘x’ may be used uninitialized in this function
drivers/input/misc/hmc5843.c:312: warning: ‘y’ may be used uninitialized in this function
drivers/input/misc/hmc5843.c:312: warning: ‘z’ may be used uninitialized in this function


> +	mutex_lock(&hmc5843->lock);
> +	if (!hmc5843_read_xyz(hmc5843, &x, &y, &z)) {
> +		input_report_abs(ipdev->input, ABS_X, x);
> +		input_report_abs(ipdev->input, ABS_Y, y);
> +		input_report_abs(ipdev->input, ABS_Z, z);
> +		input_sync(ipdev->input);
> +	}
> +	mutex_unlock(&hmc5843->lock);
> +}
> +

Some versions of gcc may not complain, but could you suppress
the warnings anyway?

regards,
dan carpenter
