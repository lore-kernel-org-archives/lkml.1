Return-Path: <linux-kernel-owner+w=401wt.eu-S1759968AbYBKS3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968AbYBKS3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:29:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbYBKS24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:28:56 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:57228 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbYBKS2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:28:54 -0500
Date: Mon, 11 Feb 2008 19:31:53 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>
Message-ID: <20080211183153.GA19771@enneenne.com>
References: <1202493644764-git-send-email-giometti@linux.it> <120249364418-git-send-email-giometti@linux.it> <20080209064531.GA29926@kroah.com> <20080211095346.GA28885@enneenne.com> <20080211152542.GD25505@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211152542.GD25505@kroah.com>
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

On Mon, Feb 11, 2008 at 07:25:42AM -0800, Greg KH wrote:
> On Mon, Feb 11, 2008 at 10:53:46AM +0100, Rodolfo Giometti wrote:
> > On Fri, Feb 08, 2008 at 10:45:31PM -0800, Greg KH wrote:
> > > 
> > > As you are adding sysfs files, please also describe them in
> > > Documentation/ABI/ in this same series of patches.
> > 
> > Ok. I'm going to add them under "testing".
> > 
> > > Why not use a default attribute group?
> > > 
> > > That way the files are created before the uevent is issued, and the
> > > amount of code you have to write is much smaller.
> > 
> > What do you mean exactly? I don't understand what you wish. :'(
> 
> If you use a 'struct device' you can use a default attribute group for
> that device to be created whenever it is added.
> 
> However you are not using the driver core that way, you are just calling
> device_create(), which doesn't work that way.
> 
> But you can just use an attribute group instead, which still saves you a
> lot of code, try using that instead (sysfs_create_group()).
> 
> Or go all the way and embed a 'struct device' in your structure, and
> create a bus, then you can use the default attribute group, although
> that might be a bit more work :)

I see but how can I manage the fact that files "assert" and "clear"
are created according to pps->info.mode field content?

See the code:

int pps_sysfs_create_source_entry(struct pps_device *pps)
{
        int ret;

        /* Create file "assert" and "clear" according to source capability */
        if (pps->info.mode & PPS_CAPTUREASSERT) {
                ret = device_create_file(pps->dev, &dev_attr_assert);
                if (ret)
                        dev_err(pps->dev, "unable to create \"assert\" "
                                        "sysfs entry");
        }

        if (pps->info.mode & PPS_CAPTURECLEAR) {
                ret = device_create_file(pps->dev, &dev_attr_clear);
                if (ret)
                        dev_err(pps->dev, "unable to create \"clear\" "
                                        "sysfs entry");
        }

        ret = device_create_file(pps->dev, &dev_attr_mode);
        if (ret)
                dev_err(pps->dev, "unable to create \"mode\" sysfs entry");

Do you think is better create these files anyway and in case report a
NULL string?

Thanks,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
