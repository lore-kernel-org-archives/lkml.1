Return-Path: <linux-kernel-owner+w=401wt.eu-S1754253AbZHTMT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbZHTMT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 08:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbZHTMT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 08:19:28 -0400
Received: from edu.joroinen.fi ([194.89.68.130]:57223 "EHLO edu.joroinen.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157AbZHTMT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 08:19:27 -0400
Date: Thu, 20 Aug 2009 15:19:28 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Nick Cheng <nick.cheng@areca.com.tw>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Michael Fuckner'" <michael@fuckner.net>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: Performance issues with Areca 1680 SAS Controllers
Message-ID: <20090820121928.GV19938@edu.joroinen.fi>
References: <20090819140848.GW19938@edu.joroinen.fi> <SERVER-ARECA8ldpyzy000025bc@areca.com.tw> <20090820095604.GT19938@edu.joroinen.fi> <20090820121602.GU19938@edu.joroinen.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090820121602.GU19938@edu.joroinen.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 03:16:02PM +0300, Pasi Kärkkäinen wrote:
> On Thu, Aug 20, 2009 at 12:56:04PM +0300, Pasi Kärkkäinen wrote:
> > On Thu, Aug 20, 2009 at 09:54:27AM +0800, Nick Cheng wrote:
> > > Hi Gentlemen,
> > > We have worked it out with new firmware and driver.
> > > You can download the latest F/W from
> > > ftp://ftp.areca.com.tw/RaidCards/BIOS_Firmware/ARC1680/ and use the attached
> > > driver.
> > > Please have a try.
> > > Any comments are welcome.
> > 
> > Thanks! I'll give it a try today and report back.
> > 
> 
> v1.47 firmware seems to fix this problem! The system behaves _much_ better
> now even when Areca is busy flushing it's cache! 
> 
> I didn't update the driver, only Areca firmware.
> 
> Is there something imported fixed in the latest driver? I'm using the
                     ^^^^^^^^

.. That should have been important :)

-- Pasi


> default driver included in RHEL/CentOS 5.3.
> 
> # modinfo arcmsr.ko
> filename:       arcmsr.ko
> version:        Driver Version 1.20.00.15.RH1 2008/02/27
> 
> -- Pasi
> 
> > 
> > > Thank you,
> > > -----Original Message-----
> > > From: Pasi Kärkkäinen [mailto:pasik@iki.fi] 
> > > Sent: Wednesday, August 19, 2009 10:09 PM
> > > To: Nick Cheng
> > > Cc: 'Andrew Morton'; 'Michael Fuckner'; linux-kernel@vger.kernel.org;
> > > linux-scsi@vger.kernel.org; 'Erich Chen'
> > > Subject: Re: Performance issues with Areca 1680 SAS Controllers
> > > 
> > > On Thu, Nov 20, 2008 at 03:39:40PM +0800, Nick Cheng wrote:
> > > > Hi Michael,
> > > > I will get around handling your issue.
> > > > Thanks for your kindly patience,
> > > > 
> > > 
> > > Hello,
> > > 
> > > Was this issue resolved? I'm seeing similar behaviour.. I think it's related
> > > to flushing the controller cache?
> > > 
> > > Waiting a while (after the disk leds stop blinking) performance is back to
> > > normal.. 
> > > 
> > > -- Pasi
> > > 
> > > > -----Original Message-----
> > > > From: Andrew Morton [mailto:akpm@linux-foundation.org] 
> > > > Sent: Thursday, November 20, 2008 9:18 AM
> > > > To: Michael Fuckner
> > > > Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Nick Cheng;
> > > > Erich Chen
> > > > Subject: Re: Performance issues with Areca 1680 SAS Controllers
> > > > 
> > > > (cc's added)
> > > > 
> > > > On Wed, 19 Nov 2008 13:16:56 +0100
> > > > Michael Fuckner <michael@fuckner.net> wrote:
> > > > 
> > > > > Hi,
> > > > > 
> > > > > I am using an Areca 1680-SAS-Controller with 16 SAS-HDD (Seagate 1TB
> > > > > ST31000640SS). I set up a Raid6 with all 16 disks and formatted it with
> > > > > XFS. The Controller has 512MB RAM and a BBU. The OS is installed to
> > > > > another disk attached to the onboard AHCI controller.
> > > > > 
> > > > > After doing some IO, the areca raidset is slower compared to the rate 
> > > > > directly
> > > > > after boot.
> > > > > 
> > > > > 
> > > > > [root@storage ~]# dd if=/dev/sdb1 of=/dev/null bs=1M count=50k
> > > > iflag=direct
> > > > > 51200+0 records in
> > > > > 51200+0 records out
> > > > > 53687091200 bytes (54 GB) copied, 59.6494 seconds, 900 MB/s
> > > > > [root@storage ~]# mount /dev/sdb1 /data
> > > > > [root@storage ~]# cd /data/
> > > > > [root@storage data]# ./iozone -i 0 -i 1 -s 32g -r 16m -S 6144 -t 8 -+r
> > > > > -o  >raid6_sync_t8.log
> > > > > [root@storage data]# cd
> > > > > [root@storage ~]# umount /data/
> > > > > [root@storage ~]# dd if=/dev/sdb1 of=/dev/null bs=1M count=50k
> > > > iflag=direct
> > > > > 51200+0 records in
> > > > > 51200+0 records out
> > > > > 53687091200 bytes (54 GB) copied, 76.4036 seconds, 703 MB/s
> > > > > 
> > > > > I tested different Versions of Linux (Centos 5.2, OpenSUSE 11, Debian
> > > > > Lenny) and Vanilla kernels 2.6.22-2.6.27, all show this behaviour.
> > > > > 
> > > > > Idea why the device slows down after IO- or better: how to keep the high
> > > > > rate? Is this reproducible foer Areca SATA Controllers (Type 11XX and
> > > > 12XX)
> > > > > 
> > > > > Regards,
> > > > >    Michael!
> > > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
