Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbYIEI63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbYIEI63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 04:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbYIEI6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 04:58:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:63608 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbYIEI57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 04:57:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MA9BbVk1hcXWcLQgMEoit2Nxo6H/1gHzcSmG0u4aUJe38du4z1Bt8uCAOSZEfRlcBY
         arC8Hi+qvZ9kUJl7a8yzv/X0g/ctXf72NxZ8fYGmrhT5a4w9zeXho3/JGbuUoM9UnCPm
         N5P/kzKouqNisPnhMKPqTausDMkCcolkN3AzI=
Message-ID: <38b2ab8a0809050157yfb21b08v23ae368d3337c1ca@mail.gmail.com>
Date: Fri, 5 Sep 2008 10:57:56 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: qestion about I2C_CLASS_HWMON flag
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       i2c@lm-sensors.org
In-Reply-To: <20080904120855.7e7b9720@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0809040043g7f944872l47f84c53bb213829@mail.gmail.com>
	 <38b2ab8a0809040105j7ae3aca8xd334a4d203d9415b@mail.gmail.com>
	 <20080904103707.557ac764@hyperion.delvare>
	 <38b2ab8a0809040149u2bc0342h5c32b87f9277322f@mail.gmail.com>
	 <20080904120855.7e7b9720@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning Jean,

On Thu, Sep 4, 2008 at 12:08 PM, Jean Delvare <khali@linux-fr.org> wrote:
> In general they can, yes (where they can't, it's due to restrictions in
> protocol implementations, not device types.) But this isn't a matter of
> what devices can be on the bus. This is a matter of what devices can be
> probed for on a given bus. For example, hardware monitoring drivers
> which handle I2C devices, make sure that I2C_CLASS_HWMON is set before
> probing I2C addresses on a given bus in search of a device to
> auto-detect. On the other hand, if they are merely attaching to an I2C
> device which has already been instantiated (and thus no probing is
> needed) they do not care about the class. The reason for this mechanism
> is that probing can be risky, so we want to limit it to what is
> strictly needed. For example, there is no point in probing the I2C bus
> of a TV adapter for hardware monitoring chips - there simply can't be
> any there. If there ever was any, that would be such a special case
> that we would instantiate the I2C device in question explicitly from
> the adapter code, so we have no need for probing.

OK but which devices that can be connected to an I2C bus is platform specific,
isn't it ? For example, an I2C adapter can be used in a TV and in that
case there
may be no point to probe for a HW mon chips but this same I2C adapter can be
used by other platforms in a different context where there's a HW mon chip.

So the flags probably are useful, but they're are hard coded in adapters...

Sorry if I'm still missing something.
-- 
Francis
