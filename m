Return-Path: <linux-kernel-owner+w=401wt.eu-S1759492AbYBKSkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492AbYBKSkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755342AbYBKSj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:39:56 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:48140 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbYBKSjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:39:55 -0500
Date: Mon, 11 Feb 2008 19:42:57 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>
Message-ID: <20080211184257.GA16773@enneenne.com>
References: <1202493644764-git-send-email-giometti@linux.it> <120249364418-git-send-email-giometti@linux.it> <20080209064531.GA29926@kroah.com> <20080211095346.GA28885@enneenne.com> <20080211152542.GD25505@kroah.com> <20080211183153.GA19771@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211183153.GA19771@enneenne.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/8] LinuxPPS core support.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 07:31:53PM +0100, Rodolfo Giometti wrote:
> Do you think is better create these files anyway and in case report a
> NULL string?

Is that ok?

/*
 * Attribute functions
 */

static ssize_t pps_show_assert(struct device *dev,
				struct device_attribute *attr, char *buf)
{
	struct pps_device *pps = dev_get_drvdata(dev);

	if (!(pps->info.mode & PPS_CAPTUREASSERT))
		return 0;

	return sprintf(buf, "%lld.%09d#%d\n",
			pps->assert_tu.sec, pps->assert_tu.nsec,
			pps->assert_sequence);
}
DEVICE_ATTR(assert, S_IRUGO, pps_show_assert, NULL);

static ssize_t pps_show_clear(struct device *dev,
				struct device_attribute *attr, char *buf)
{
	struct pps_device *pps = dev_get_drvdata(dev);

	if (!(pps->info.mode & PPS_CAPTURECLEAR))
		return 0;

	return sprintf(buf, "%lld.%09d#%d\n",
			pps->clear_tu.sec, pps->clear_tu.nsec,
			pps->clear_sequence);
}
DEVICE_ATTR(clear, S_IRUGO, pps_show_clear, NULL);

static ssize_t pps_show_mode(struct device *dev,
				struct device_attribute *attr, char *buf)
{
	struct pps_device *pps = dev_get_drvdata(dev);

	return sprintf(buf, "%4x\n", pps->info.mode);
}
DEVICE_ATTR(mode, S_IRUGO, pps_show_mode, NULL);

...

static struct attribute *pps_attrs[] = {
	&dev_attr_mode.attr,
	&dev_attr_echo.attr,
	&dev_attr_name.attr,
	&dev_attr_path.attr,
	&dev_attr_assert.attr,
	&dev_attr_clear.attr,
	NULL
};

static struct attribute_group pps_group = {
	.attrs = pps_attrs,
};

/*
 * Public functions
 */

void pps_sysfs_remove_source_entry(struct pps_device *pps)
{
	/* Delete info files */
	sysfs_remove_group(&pps->dev->kobj, &pps_group);
}

int pps_sysfs_create_source_entry(struct pps_device *pps)
{
	int ret;

	/* Create info files */
	ret = sysfs_create_group(&pps->dev->kobj, &pps_group);
	if (ret)
		dev_err(pps->dev, "unable to create default sysfs entries");

	return 0;
}

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
