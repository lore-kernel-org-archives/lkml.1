Return-Path: <linux-kernel-owner+w=401wt.eu-S932810AbZHDO7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810AbZHDO7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932291AbZHDO7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:59:18 -0400
Received: from gw1.transmode.se ([213.115.205.20]:48711 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290AbZHDO7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:59:17 -0400
In-Reply-To: <20090804142250.GA17398@oksana.dev.rtsoft.ru>
References: <20090713222005.GA19859@oksana.dev.rtsoft.ru> <20090713151911.GA28114@oksana.dev.rtsoft.ru> <OFF188389D.68E638A2-ONC12575F2.00568C5B-C12575F2.0057FC95@transmode.se> <20090713173455.GA9866@oksana.dev.rtsoft.ru> <OF9378E65D.FBBCCFD5-ONC12575F2.006B28D5-C12575F2.006DDAE5@transmode.se> <OF613F53BF.1FD77EDB-ONC12575F3.00753535-C12575F3.00753537@transmode.se> <20090714220931.GA11378@oksana.dev.rtsoft.ru> <OF9A2BDEDE.DC0DE0D4-ONC1257608.004A7A59-C1257608.004AF3BF@transmode.se> <20090804142250.GA17398@oksana.dev.rtsoft.ru>
Subject: Re: Ang: Re: [PATCH 0/2] Setting GPIOs simultaneously
X-KeepSent: C7025845:8BE60C98-C1257608:0051D318;
 type=4; name=$KeepSent
To: avorontsov@ru.mvista.com
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
X-Mailer: Lotus Notes Release 8.5 December 05, 2008
Message-ID: <OFC7025845.8BE60C98-ONC1257608.0051D318-C1257608.00525388@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Tue, 4 Aug 2009 16:59:13 +0200
X-MIMETrack: Serialize by Router on sesr04/Transmode(Release 8.5 HF407|May 07, 2009) at
 2009-08-04 16:59:15
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov <avorontsov@ru.mvista.com> wrote on 04/08/2009 16:22:50:
>
> On Tue, Aug 04, 2009 at 03:38:40PM +0200, Joakim Tjernlund wrote:
> > Anton Vorontsov <avorontsov@ru.mvista.com> wrote on 15/07/2009 00:09:31:
> > >
> > > On Tue, Jul 14, 2009 at 11:20:13PM +0200, Joakim Tjernlund wrote:
> > > [...]
> > > > >But any users of the legacy bindings should be in-tree.
> > > >
> > > > ehh, it was working until you made it OF only. Why do call the native
> > > > way legacy?  It is the method all non OF arch uses.
> > >
> > > It's legacy because there are no in-tree users anymore. Nowadays
> > > we're trying to pass all needed information via OF, and we're
> > > trying to avoid ugly platform-dependant hacks. Your SPI scheme
> > > can be easily described via OF, but sure, it's hard to implement
> > > it with the current SPI/OF subsystem.
> >
> > Sorry for the long delay, I have been on vaction and been busy with other stuff.
> >
> > Tell me, how does this new OF SPI device scheme work out if you want
> > to use the bitbanged SPI driver?
>
> spi-controller {
>    ...
>    compatible = "generic-bitbang-spi";
>    gpios = <GPIO_CLK GPIO_MOSI GPIO_MISO>;
>    spi,chip-select-machines = <&gpio_csm &board_csm>;
>
>    gpio_csm: chip-select-machine {
>       #address-cells = <1>;
>       #size-cells = <0>;
>       compatible = "generic-gpio-csm";
>       gpios = <GPIO_CS1 GPIO_CS2>;
>
>       touchscreen@0 {
>          reg = <0>; /* using GPIO CS1 */
>       };
>
>       eeprom@1 {
>          reg = <1>; /* using GPIO CS2 */
>       };
>    };
> };
>
> localbus {
>    ...
>    board_csm: chip-select-machine {
>       #address-cells = <1>;
>       #size-cells = <0>;
>       compatibe = "board-specific-csm";
>
>       light-sensor@0 {
>          reg = <0>; /* using board-specific "CS3" */
>       };
>
>       battery@1 {
>          reg = <1>; /* using board-specific "CS4" */
>       };
>    };
> };

hmm, this looks promising. Can I write my own board-specific-csm
and attach it to the SPI CS engine? I don't quite
se how, the 8xxx SPI driver only looks for gpio functions.
Perhaps this is something that you are working on?

       Jocke

