Return-Path: <linux-kernel-owner+w=401wt.eu-S1756332Ab0AMVta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab0AMVta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 16:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812Ab0AMVt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 16:49:29 -0500
Received: from www17.your-server.de ([213.133.104.17]:59046 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab0AMVt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 16:49:28 -0500
Subject: Re: [Bug #14670] i915: playing video via XVideo extension makes
 the screen flicker
From: Thomas Meyer <thomas@m3y3r.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>
In-Reply-To: <20100112095702.4b22fcc1@jbarnes-piketon>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
	 <CXIfLt-ygXM.A.GGD.GilSLB@chimera>
	 <1263228784.12830.0.camel@localhost.localdomain>
	 <20100111085527.104f5c3e@jbarnes-piketon>
	 <8B599161-2977-4A43-B88F-36E87AFCF4EA@m3y3r.de>
	 <20100111111941.189eb41e@jbarnes-piketon>
	 <1263318189.3284.2.camel@localhost.localdomain>
	 <20100112095702.4b22fcc1@jbarnes-piketon>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jan 2010 22:48:40 +0100
Message-ID: <1263419320.2250.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 12.01.2010, 09:57 -0800 schrieb Jesse Barnes:
> On Tue, 12 Jan 2010 18:43:09 +0100
> Thomas Meyer <thomas@m3y3r.de> wrote:
> 
> > Am Montag, den 11.01.2010, 11:19 -0800 schrieb Jesse Barnes:
> > > On Mon, 11 Jan 2010 20:03:57 +0100
> > > Thomas Meyer <thomas@m3y3r.de> wrote:
> > > 
> > > > 
> > > > 
> > > > Am 11.01.2010 um 17:55 schrieb Jesse Barnes
> > > > <jbarnes@virtuousgeek.org>:
> > > > 
> > > > > On Mon, 11 Jan 2010 17:53:04 +0100
> > > > > Thomas Meyer <thomas@m3y3r.de> wrote:
> > > > >
> > > > >> Am Sonntag, den 10.01.2010, 23:56 +0100 schrieb Rafael J.
> > > > >> Wysocki:
> > > > >>> This message has been generated automatically as a part of a
> > > > >>> report of regressions introduced between 2.6.31 and 2.6.32.
> > > > >>>
> > > > >>> The following bug entry is on the current list of known
> > > > >>> regressions introduced between 2.6.31 and 2.6.32.  Please
> > > > >>> verify if it still should be listed and let me know (either
> > > > >>> way).
> > > > >>>
> > > > >>
> > > > >> Yes, still should be listed.
> > > > >>
> > > > >> Problem still exists in 2.6.32.3 and 2.6.33-rc3-00097-g2c1f189,
> > > > >> that contains
> > > > >> this commit:
> > > > >> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=cda9d05c499093c67b4a376a15009923acc2127a
> > > > >>
> > > > >> The above commit removes the render reclock support, that
> > > > >> ought to fix a common kind of problem encountered on i915
> > > > >> hardware, but not on my machine.
> > > > >>
> > > > >> Still need to boot with "nomodeset" to have a workable system.
> > > > >
> > > > > Does this patch prevent the flicker?
> > > > 
> > > > By the way: how often and in what interval is the function   
> > > > intel_lvds_detect called?
> > > > 
> > > > How long will/can the function acpi_lid_open take to complete?
> > > > Maybe some acpi interpretation takes really long? Is this
> > > > possible?
> > > > 
> > > > Would this explain the flickering?
> > > 
> > > It should only be called when a client requests the connection
> > > status (e.g. xrandr or the GNOME display applet).
> > 
> > how to check how often this function is called and it's duration? is
> > the function tracer capable of this?
> 
> Yeah, the function tracer should be able to do it (though I don't know
> how to use it offhand, maybe through the perf tool?).  Or you could
> just add some DRM_ERROR lines. :)


After recompiling the kernel without optimize for size I could use the
function graph tracer and set the function to "intel_lvds_detect".

Here is an example of the output:

 0)   0.365 us    |                up();
 0)   1.092 us    |              }
 0)   1.824 us    |            }
 0)   2.486 us    |          }
 0)   0.376 us    |          kfree();
 0) ! 9759.012 us |        }
 0) ! 9759.813 us |      }
 0) ! 9761.096 us |    }
 0) ! 9764.483 us |  }
 0)               |  intel_lvds_detect() {
 0)               |    acpi_lid_open() {
 0)               |      acpi_evaluate_integer() {
 0)               |        acpi_evaluate_object() {
 0)               |          acpi_os_allocate_zeroed() {
 0)               |            __kmalloc() {
 0)   0.366 us    |              get_slab();
 0)   0.336 us    |              _cond_resched();
 0)   0.396 us    |              memset();
 0)   2.796 us    |            }
 0)   3.447 us    |          }
 0)   0.531 us    |          acpi_ns_validate_handle();

So the call to "intel_lvds_detect" seems to take around 10000us, i.e.
10ms (I guess this is long), thanks to heavy ACPI interpretation.

So the question still is: Why is the drm_ioctl (that in turn calls
intel_lvds_detect) called so often by Xorg?

greets
thomas


