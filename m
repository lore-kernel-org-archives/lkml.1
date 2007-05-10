Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbXEJQyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbXEJQyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 12:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbXEJQyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 12:54:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216AbXEJQyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 12:54:03 -0400
Subject: Re: Please pull 'revert-libertas' branch of wireless-2.6
From: Dan Williams <dcbw@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Marcelo Tosatti <marcelo@kvack.org>, Jeff Garzik <jeff@garzik.org>,
       David Miller <davem@davemloft.net>, penberg@cs.helsinki.fi,
       linville@tuxdriver.com, hch@infradead.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
In-Reply-To: <4642411E.7000307@oracle.com>
References: <20070507141143.GB5125@tuxdriver.com>
	 <463F443A.5000306@garzik.org>
	 <84144f020705080247v74ebcd26y27c2f1e61529b215@mail.gmail.com>
	 <20070508.132737.104034594.davem@davemloft.net>
	 <4640E3BF.8080401@garzik.org>
	 <1178659763.14888.2.camel@localhost.localdomain>
	 <4640FC76.4090908@garzik.org> <20070508234118.GA3472@dmt>
	 <1178674020.16181.4.camel@localhost.localdomain>
	 <20070509142516.a31467c5.randy.dunlap@oracle.com>
	 <1178746884.9590.18.camel@localhost.localdomain>
	 <4642411E.7000307@oracle.com>
Content-Type: text/plain
Date: Thu, 10 May 2007 12:56:39 -0400
Message-Id: <1178816199.29885.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 14:46 -0700, Randy Dunlap wrote:
> Dan Williams wrote:
> > On Wed, 2007-05-09 at 14:25 -0700, Randy Dunlap wrote:
> >> On Tue, 08 May 2007 21:27:00 -0400 Dan Williams wrote:
> >>
> >>> On Tue, 2007-05-08 at 20:41 -0300, Marcelo Tosatti wrote:
> >>>> On Tue, May 08, 2007 at 06:40:54PM -0400, Jeff Garzik wrote:
> >>>>> Dan Williams wrote:
> >>>>>> I'll audit the list of ioctls and remove ones that may be objectionable,
> >>>>>> and we'll go back through them after 2.6.22 and add back in ones that
> >>>>>> are actually required.  Keep the API/ABI small and expand if necessary.
> >>>>>> What's the timeframe required here?  Linville said a few days at the
> >>>>>> most.
> >>>>> Ideally, before 2.6.22-rc1.  No set date, but generally it's a week or 
> >>>>> two after merge window opens.
> >>>>>
> >>>>> But even if you miss -rc1, we MUST get in the ioctl removal before 
> >>>>> 2.6.22 release.  This is certainly exception to the "nothing but bug 
> >>>>> fixes" rule -- or perhaps it is following the rule, if you consider the 
> >>>>> ioctls' existence a bug :)
> >>>>>
> >>>>> Getting the CodingStyle fixes in before 2.6.22-rc1 would be nice, but, 
> >>>>> as I noted, lower priority than serious stuff like ioctl consideration.
> >>>> There is also a bunch of updates pending. I'm sending them over this
> >>>> week.
> >>>>
> >>>> Dan: I'll be sending everything thats currently in our tree but not
> >>>> mainline.
> >>> I'm going through the ioctls as we speak...  what else was pending?
> >> All of the printk format warnings & cast warnings from 2.6.21-mm2 ??
> > 
> > I can fix those up; but setting KBUILD_VERBOSE=1 and recompiling doesn't
> > show any of them in current libertas-2.6; -Wall is definitely defined.
> > Is there another way to enable something give yet more verbose debug
> > output?
> 
> No, I think that it's just host arch. and/or gcc dependent.
> 
> I built on x86_64.  Can you do that?

Trying to scrape one up.  Should be doable by the end of today.

Dan

> 
> > Thanks,
> > Dan
> > 
> >> drivers/net/wireless/libertas/rx.c: In function 'libertas_process_rxed_packet':
> >> drivers/net/wireless/libertas/rx.c:213: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
> >> drivers/net/wireless/libertas/rx.c:213: warning: format '%d' expects type 'int', but argument 4 has type 'long unsigned int'
> >> drivers/net/wireless/libertas/rx.c: In function 'process_rxed_802_11_packet':
> >> drivers/net/wireless/libertas/rx.c:367: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
> >> drivers/net/wireless/libertas/rx.c:367: warning: format '%d' expects type 'int', but argument 4 has type 'long unsigned int'
> >> drivers/net/wireless/libertas/tx.c: In function 'SendSinglePacket':
> >> drivers/net/wireless/libertas/tx.c:81: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
> >> drivers/net/wireless/libertas/cmd.c: In function 'libertas_queue_cmd':
> >> drivers/net/wireless/libertas/cmd.c:950: warning: cast from pointer to integer of different size
> >> drivers/net/wireless/libertas/cmd.c: In function 'DownloadcommandToStation':
> >> drivers/net/wireless/libertas/cmd.c:979: warning: cast from pointer to integer of different size
> >> drivers/net/wireless/libertas/cmd.c:979: warning: cast from pointer to integer of different size
> >> drivers/net/wireless/libertas/cmd.c: In function 'libertas_prepare_and_send_command':
> >> drivers/net/wireless/libertas/cmd.c:1177: warning: cast from pointer to integer of different size
> >> drivers/net/wireless/libertas/scan.c: In function 'InterpretBSSDescriptionWithIE':
> >> drivers/net/wireless/libertas/scan.c:1118: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
> >> drivers/net/wireless/libertas/scan.c: In function 'libertas_get_scan':
> >> drivers/net/wireless/libertas/scan.c:1586: warning: format '%d' expects type 'int', but argument 5 has type 'long unsigned int'
> >> drivers/net/wireless/libertas/join.c: In function 'libertas_cmd_80211_ad_hoc_join':
> >> drivers/net/wireless/libertas/join.c:789: warning: cast from pointer to integer of different size
> >> drivers/net/wireless/libertas/ioctl.c: In function 'wlan_set_linkmode_ioctl':
> >> drivers/net/wireless/libertas/ioctl.c:696: warning: cast from pointer to integer of different size
> >> drivers/net/wireless/libertas/ioctl.c: In function 'wlan_set_radiomode_ioctl':
> >> drivers/net/wireless/libertas/ioctl.c:728: warning: cast from pointer to integer of different size
> >> drivers/net/wireless/libertas/ioctl.c: In function 'wlan_set_debugmode_ioctl':
> >> drivers/net/wireless/libertas/ioctl.c:757: warning: cast from pointer to integer of different size
> >> drivers/net/wireless/libertas/ioctl.c: In function 'wlan_fwt_cleanup_ioctl':
> >> drivers/net/wireless/libertas/ioctl.c:1779: warning: cast to pointer from integer of different size
> >> drivers/net/wireless/libertas/ioctl.c: In function 'wlan_fwt_time_ioctl':
> >> drivers/net/wireless/libertas/ioctl.c:1810: warning: cast to pointer from integer of different size
> >> drivers/net/wireless/libertas/ioctl.c: In function 'wlan_mesh_get_ttl_ioctl':
> >> drivers/net/wireless/libertas/ioctl.c:1839: warning: cast to pointer from integer of different size
> >> drivers/net/wireless/libertas/ioctl.c: In function 'libertas_do_ioctl':
> >> drivers/net/wireless/libertas/ioctl.c:1947: warning: cast from pointer to integer of different size
> >> drivers/net/wireless/libertas/ioctl.c:2025: warning: cast from pointer to integer of different size
> >> drivers/net/wireless/libertas/ioctl.c:2171: warning: cast from pointer to integer of different size
> >> drivers/net/wireless/libertas/ioctl.c:2188: warning: cast to pointer from integer of different size
> >> drivers/net/wireless/libertas/ioctl.c:2192: warning: cast to pointer from integer of different size
> >> drivers/net/wireless/libertas/ioctl.c:2196: warning: cast to pointer from integer of different size
> >> drivers/net/wireless/libertas/debugfs.c: In function 'libertas_parse_ssid':
> >> drivers/net/wireless/libertas/debugfs.c:279: warning: comparison of distinct pointer types lacks a cast
> >> drivers/net/wireless/libertas/debugfs.c: In function 'wlan_debugfs_read':
> >> drivers/net/wireless/libertas/debugfs.c:1823: warning: cast to pointer from integer of different size
> >> drivers/net/wireless/libertas/debugfs.c:1825: warning: cast to pointer from integer of different size
> >> drivers/net/wireless/libertas/debugfs.c:1827: warning: cast to pointer from integer of different size
> >> drivers/net/wireless/libertas/debugfs.c: In function 'wlan_debugfs_write':
> >> drivers/net/wireless/libertas/debugfs.c:1884: warning: cast to pointer from integer of different size
> >> drivers/net/wireless/libertas/debugfs.c:1886: warning: cast to pointer from integer of different size
> >> drivers/net/wireless/libertas/debugfs.c:1888: warning: cast to pointer from integer of different size
> >> drivers/net/wireless/libertas/debugfs.c: At top level:
> >> drivers/net/wireless/libertas/debugfs.c:1900: warning: initialization from incompatible pointer type
> >> drivers/net/wireless/libertas/debugfs.c: In function 'libertas_debug_init':
> >> drivers/net/wireless/libertas/debugfs.c:1919: warning: cast from pointer to integer of different size
> >> drivers/net/wireless/libertas/if_usb.c: In function '__if_usb_submit_rx_urb':
> >> drivers/net/wireless/libertas/if_usb.c:393: warning: passing argument 4 of 'usb_fill_bulk_urb' makes pointer from integer without a cast
> >>
> >>
> >>
> >>
> >>> Louis has a few on libertas-dev list.  We also need to pull wireless-2.6
> >>> into libertas before we send linville a pull request, I think.
> 
> 

