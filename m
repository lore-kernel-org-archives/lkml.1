Return-Path: <linux-kernel-owner+w=401wt.eu-S1759380AbYCURBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380AbYCURBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 13:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbYCURAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 13:00:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:59301 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbYCURAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 13:00:53 -0400
Subject: Re: [PATCH 1/7] LinuxPPS core support.
From: Kay Sievers <kay.sievers@vrfy.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <20080321105649.GA8959@enneenne.com>
References: <12048053463198-git-send-email-giometti@linux.it>
	 <12048053473401-git-send-email-giometti@linux.it>
	 <3ae72650803202036i7aee418et23b1ec5ac72560f7@mail.gmail.com>
	 <20080321105649.GA8959@enneenne.com>
Content-Type: text/plain
Date: Fri, 21 Mar 2008 18:00:05 +0100
Message-Id: <1206118805.24338.7.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18cBGzB9JB/RpICF2VXS/wpJKFrx5IiRnw+g3a
 15sYXQsruGdfgosFPoC6EOQbAFS86iaUzG2ZsOI1GlrPiWQ3pV
 8TfTpYfcpscJdnUKFDeCBIwUHUDGpfZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-21 at 11:56 +0100, Rodolfo Giometti wrote:
> On Fri, Mar 21, 2008 at 04:36:44AM +0100, Kay Sievers wrote:
> > On Thu, Mar 6, 2008 at 1:09 PM, Rodolfo Giometti <giometti@linux.it> wrote:
> > > This patch adds the kernel side of the PPS support currently named
> > >  "LinuxPPS".
> > 
> > >  diff --git a/drivers/pps/sysfs.c b/drivers/pps/sysfs.c
> > >  new file mode 100644
> > >  index 0000000..c25c91c
> > >  --- /dev/null
> > >  +++ b/drivers/pps/sysfs.c
> > >  @@ -0,0 +1,130 @@
> > 
> > >  +void pps_sysfs_remove_source_entry(struct pps_device *pps)
> > >  +{
> > >  +       /* Delete info files */
> > >  +       sysfs_remove_group(&pps->dev->kobj, &pps_group);
> > >  +}
> > >  +
> > >  +int pps_sysfs_create_source_entry(struct pps_device *pps)
> > >  +{
> > >  +       int ret;
> > >  +
> > >  +       /* Create info files */
> > >  +       ret = sysfs_create_group(&pps->dev->kobj, &pps_group);
> > 
> > Any specific reason you are creating the group by hand, and not assign
> > it to the default group in your class? It would will let the core
> > handle it for you. The device add uevent to userspace will happen
> > before you added the attributes, which is usually not nice.
> 
> No any specific reason... I just supposed it was the-right-think(TM)!
> :)
> 
> Can you please suggest me an URL where I can see how to rework the
> code?

You can assign class->dev_attrs the array of attributes, and the driver
core will create these attributes for all devices that get registered
with that class. See: drivers/base/core.c :: device_add_attrs().

Kay

