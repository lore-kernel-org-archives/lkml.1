Return-Path: <linux-kernel-owner+w=401wt.eu-S1753017AbZCHKri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbZCHKri (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 06:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbZCHKrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 06:47:25 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:43573 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbZCHKrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 06:47:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer;
        b=VQe85bKTqUJtyLr5AqZNBa400MtqXh+tdIs5Lx+CBe59dKJU1+Q/vqD+QO4BGg5Xdt
         nNXXFZVUt3L4Eaq0bQj0IfcqCZx4AW7hoFok2T6dUWioE+pVkdnB5jH6IkZWFdjtjZmh
         uFcyLOUuq0dd7+pSTEVn5DNVHiQHGtR1wILvw=
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
From: Andreas Robinson <andr345@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Rusty Russell <rusty@rustcorp.com.au>,
       sam@ravnborg.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090306074548.36ed2f9f@infradead.org>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
	 <ac3eb2510902170353ia62a630nbe5cf059ca7d616e@mail.gmail.com>
	 <200902181528.29697.rusty@rustcorp.com.au>
	 <ac3eb2510902180115o4690a335n129e4df695540de0@mail.gmail.com>
	 <1234952753.10531.48.camel@andreas-laptop>
	 <cc43514a0902191637h5a9680c5id95f7d6c32cca472@mail.gmail.com>
	 <ac3eb2510902191755i391d4defnc5a514f4525ec6cf@mail.gmail.com>
	 <1235216636.7025.1023.camel@andreas-laptop>
	 <1236004353.10055.49.camel@andreas-laptop>
	 <20090302082003.1bb7bdc5@infradead.org>
	 <ac3eb2510903020829s7c876a96y7eb5568eeb9921fd@mail.gmail.com>
	 <20090302102703.50aaf724@infradead.org>
	 <1236192430.6785.111.camel@andreas-laptop>
	 <20090305161837.6ba80cc1@infradead.org>
	 <1236352543.6594.59.camel@andreas-laptop>
	 <20090306074548.36ed2f9f@infradead.org>
Content-Type: multipart/mixed; boundary="=-5hiiqUwNgeHgNc1ewLxC"
Date: Sun, 08 Mar 2009 11:47:17 +0100
Message-Id: <1236509237.5645.151.camel@andreas-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5hiiqUwNgeHgNc1ewLxC
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2009-03-06 at 07:45 -0800, Arjan van de Ven wrote: 
> On Fri, 06 Mar 2009 16:15:43 +0100
> Andreas Robinson <andr345@gmail.com> wrote:
> 
> > On Thu, 2009-03-05 at 16:18 -0800, Arjan van de Ven wrote:
> > > On Wed, 04 Mar 2009 19:47:10 +0100
> > > Andreas Robinson <andr345@gmail.com> wrote:
> > > 
> > > the only thing I can say (the graphs are a bit complex to read) is
> > > that you are loading a LOT of very expensive modules that bring you
> > > no functionality.
> > 
> > Well, yes. It is the generic Ubuntu kernel booting in all its bloaty
> > glory. :) But this is what most users are stuck with. The distro
> > vendors won't change their ways because they want their stuff to run
> > on anything.
> 
> the problem is that you are also having things that just don't make
> sense; even for the generalized case...
> 
> but I guess that is for Ubuntu to resolve. I don't see the machines I
> run (with Fedora) exhibit this same issue; while there are a bunch of
> modules, none of the ones that are expensive-and-useless in your charts
> are there.

I think they will. Fast boot is one of the "essential" goals for Jaunty
and Karmic.

Anyway, attached is a bootchart for a cleaned up kernel with the
important (AFAIK) drivers built in.

>From this, I've found some tasks that I can set myself to. They would
obviously be the topic of other threads:

* Make the nforce2 ethernet driver (init_nic) initialize itself
  asynchronously, if possible.

* New config option: Separate initramfs decompression and
  file-system calls. Decompress as early as possible in a
  separate thread.

* Don't unpack initramfs twice. If CONFIG_BLK_DEV_RAM is
  set, the kernel decompresses the ramdisk just to see if
  it's a cpio archive or not, and then throws away the result.

* See what can be done about pci_init(), if anything.

If there's anything else regarding fastboot you think would make more
sense to work on first, please let me know.

Thanks,
Andreas


--=-5hiiqUwNgeHgNc1ewLxC
Content-Disposition: attachment; filename="hp_bg.svg"
Content-Type: image/svg+xml; name="hp_bg.svg"
Content-Transfer-Encoding: 7bit

<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg
   xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:cc="http://creativecommons.org/ns#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:svg="http://www.w3.org/2000/svg"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
   width="955.70898"
   height="1950.6189"
   version="1.0"
   id="svg2"
   sodipodi:version="0.32"
   inkscape:version="0.46"
   sodipodi:docname="hp_bg.svg"
   inkscape:output_extension="org.inkscape.output.svg.inkscape">
  <metadata
     id="metadata181">
    <rdf:RDF>
      <cc:Work
         rdf:about="">
        <dc:format>image/svg+xml</dc:format>
        <dc:type
           rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
      </cc:Work>
    </rdf:RDF>
  </metadata>
  <defs
     id="defs179">
    <inkscape:perspective
       sodipodi:type="inkscape:persp3d"
       inkscape:vp_x="0 : 0.5 : 1"
       inkscape:vp_y="0 : 1000 : 0"
       inkscape:vp_z="2000 : 0.5 : 1"
       inkscape:persp3d-origin="1000 : 0.33333333 : 1"
       id="perspective183" />
  </defs>
  <sodipodi:namedview
     inkscape:window-height="718"
     inkscape:window-width="645"
     inkscape:pageshadow="2"
     inkscape:pageopacity="0.0"
     guidetolerance="10.0"
     gridtolerance="10.0"
     objecttolerance="10.0"
     borderopacity="1.0"
     bordercolor="#666666"
     pagecolor="#ffffff"
     id="base"
     showgrid="false"
     inkscape:zoom="0.272"
     inkscape:cx="1000"
     inkscape:cy="526.18109"
     inkscape:window-x="0"
     inkscape:window-y="25"
     inkscape:current-layer="svg2" />
  <g
     id="g2556"
     transform="matrix(0,-1,1,0,-89.791016,1950.4489)">
    <rect
       id="rect4"
       style="fill:#0000ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="3.9511402"
       x="60.090076" />
    <text
       id="text6"
       font-size="3pt"
       transform="matrix(0,1,-1,0,61.090077,154)"
       style="font-size:3.75px">param_sysfs_init</text>
    <rect
       id="rect8"
       style="fill:#00ff00;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="3.8138752"
       x="64.749084" />
    <text
       id="text10"
       font-size="3pt"
       transform="matrix(0,1,-1,0,65.749086,154)"
       style="font-size:3.75px">acpi_init</text>
    <rect
       id="rect12"
       style="fill:#ff0014;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="5.3514895"
       x="68.599892" />
    <text
       id="text14"
       font-size="3pt"
       transform="matrix(0,1,-1,0,69.599893,154)"
       style="font-size:3.75px">acpi_scan_init</text>
    <rect
       id="rect16"
       style="fill:#ffff14;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="29.299006"
       x="74.139122" />
    <text
       id="text18"
       transform="matrix(0,1,-1,0,80.139122,154)">acpi_pci_root_init</text>
    <rect
       id="rect20"
       style="fill:#ff00ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="5.8685417"
       x="103.46029" />
    <text
       id="text22"
       font-size="3pt"
       transform="matrix(0,1,-1,0,104.46029,154)"
       style="font-size:3.75px">acpi_pci_link_init</text>
    <rect
       id="rect24"
       style="fill:#00ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="9.6848793"
       x="113.43694" />
    <text
       id="text26"
       font-size="3pt"
       transform="matrix(0,1,-1,0,114.43693,154)"
       style="font-size:3.75px">genl_init</text>
    <rect
       id="rect28"
       style="fill:#0080ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="4.2028952"
       x="123.84076" />
    <text
       id="text30"
       font-size="3pt"
       transform="matrix(0,1,-1,0,124.84076,154)"
       style="font-size:3.75px">hpet_late_init</text>
    <rect
       id="rect32"
       style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="9.1659803"
       x="128.74414" />
    <text
       id="text34"
       font-size="3pt"
       transform="matrix(0,1,-1,0,129.74414,154)"
       style="font-size:3.75px">acpi_event_init</text>
    <rect
       id="rect36"
       style="fill:#ff0080;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="2.976743"
       x="137.94766" />
    <text
       id="text38"
       font-size="3pt"
       transform="matrix(0,1,-1,0,138.94767,154)"
       style="font-size:3.75px">pnpacpi_init</text>
    <rect
       id="rect40"
       style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="21.30378"
       x="142.69962" />
    <text
       id="text42"
       transform="matrix(0,1,-1,0,148.69962,154)">init_acpi_pm_clocksource</text>
    <rect
       id="rect44"
       style="fill:#ff80ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="35.184784"
       x="164.95256" />
    <text
       id="text46"
       transform="matrix(0,1,-1,0,170.95256,154)">inet_init</text>
    <rect
       id="rect48"
       style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="193.75482"
       x="200.30908" />
    <text
       id="text50"
       transform="matrix(0,1,-1,0,206.30908,154)">populate_rootfs</text>
    <rect
       id="rect52"
       style="fill:#0000ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="4.8652143"
       x="398.86264" />
    <text
       id="text54"
       font-size="3pt"
       transform="matrix(0,1,-1,0,399.86264,154)"
       style="font-size:3.75px">init_kprobes</text>
    <rect
       id="rect56"
       style="fill:#00ff00;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="2.1254537"
       x="405.48154" />
    <text
       id="text58"
       font-size="3pt"
       transform="matrix(0,1,-1,0,406.48153,154)"
       style="font-size:3.75px">slab_sysfs_init</text>
    <rect
       id="rect60"
       style="fill:#ff0014;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="133.12677"
       x="414.36127" />
    <text
       id="text62"
       transform="matrix(0,1,-1,0,420.36128,154)">pci_init</text>
    <rect
       id="rect64"
       style="fill:#ffff14;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="2.2233243"
       x="552.3988" />
    <text
       id="text66"
       font-size="3pt"
       transform="matrix(0,1,-1,0,553.39882,154)"
       style="font-size:3.75px">acpi_container_init</text>
    <rect
       id="rect68"
       style="fill:#ff00ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="1.9309436"
       x="554.65906" />
    <text
       id="text70"
       font-size="3pt"
       transform="matrix(0,1,-1,0,555.65907,154)"
       style="font-size:3.75px">acpi_thermal_init</text>
    <rect
       id="rect72"
       style="fill:#00ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="32.384701"
       x="556.74146" />
    <text
       id="text74"
       transform="matrix(0,1,-1,0,562.74144,154)">tty_init</text>
    <rect
       id="rect76"
       style="fill:#0080ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="26.984583"
       x="589.16986" />
    <text
       id="text78"
       transform="matrix(0,1,-1,0,595.16984,154)">pty_init</text>
    <rect
       id="rect80"
       style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="320.23315"
       x="618.58704" />
    <text
       id="text82"
       transform="matrix(0,1,-1,0,624.58703,154)">init_nic</text>
    <rect
       id="rect84"
       style="fill:#ff0080;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="300"
       width="554.53906"
       x="940.7019" />
    <text
       id="text86"
       transform="matrix(0,1,-1,0,946.7019,304)">1_async_port_probe</text>
    <rect
       id="rect88"
       style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="450"
       width="1006.1564"
       x="940.85333" />
    <text
       id="text90"
       transform="matrix(0,1,-1,0,946.85332,454)">2_async_port_probe</text>
    <rect
       id="rect92"
       style="fill:#808080;fill-opacity:0.5;stroke:#000000;stroke-width:0"
       height="115"
       y="465"
       width="554.39929"
       x="940.89642" />
    <rect
       id="rect94"
       style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="36.522964"
       x="941.74829" />
    <text
       id="text96"
       transform="matrix(0,1,-1,0,947.74831,154)">ohci1394_init</text>
    <rect
       id="rect98"
       style="fill:#0000ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="600"
       width="1007.6047"
       x="942.14288" />
    <text
       id="text100"
       transform="matrix(0,1,-1,0,948.14287,604)">3_async_port_probe</text>
    <rect
       id="rect102"
       style="fill:#00ff00;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="750"
       width="1007.6503"
       x="942.29858" />
    <text
       id="text104"
       transform="matrix(0,1,-1,0,948.29861,754)">4_async_port_probe</text>
    <rect
       id="rect106"
       style="fill:#808080;fill-opacity:0.5;stroke:#000000;stroke-width:0"
       height="115"
       y="765"
       width="1007.4644"
       x="942.34045" />
    <rect
       id="rect108"
       style="fill:#ffff14;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="8.6704721"
       x="978.45038" />
    <text
       id="text110"
       font-size="3pt"
       transform="matrix(0,1,-1,0,979.4504,154)"
       style="font-size:3.75px">ehci_hcd_init</text>
    <rect
       id="rect112"
       style="fill:#ff00ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="36.284134"
       x="987.16333" />
    <text
       id="text114"
       transform="matrix(0,1,-1,0,993.16334,154)">ohci_hcd_mod_init</text>
    <rect
       id="rect116"
       style="fill:#00ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="11.23542"
       x="1023.6561" />
    <text
       id="text118"
       font-size="3pt"
       transform="matrix(0,1,-1,0,1024.6561,154)"
       style="font-size:3.75px">i8042_init</text>
    <rect
       id="rect120"
       style="fill:#0080ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="4.8855271"
       x="1037.4393" />
    <text
       id="text122"
       font-size="3pt"
       transform="matrix(0,1,-1,0,1038.4393,154)"
       style="font-size:3.75px">sdhci_drv_init</text>
    <rect
       id="rect124"
       style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="2.7188325"
       x="1042.3679" />
    <text
       id="text126"
       font-size="3pt"
       transform="matrix(0,1,-1,0,1043.3679,154)"
       style="font-size:3.75px">ricoh_mmc_drv_init</text>
    <rect
       id="rect128"
       style="fill:#ff0080;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="4.9957085"
       x="1045.1304" />
    <text
       id="text130"
       font-size="3pt"
       transform="matrix(0,1,-1,0,1046.1304,154)"
       style="font-size:3.75px">init_soundcore</text>
    <rect
       id="rect132"
       style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="4.0742478"
       x="1050.6986" />
    <text
       id="text134"
       font-size="3pt"
       transform="matrix(0,1,-1,0,1051.6986,154)"
       style="font-size:3.75px">alsa_seq_oss_init</text>
    <rect
       id="rect136"
       style="fill:#ff80ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="150"
       width="220.47842"
       x="1055.2812" />
    <text
       id="text138"
       transform="matrix(0,1,-1,0,1061.2813,154)">alsa_card_azx_init</text>
    <rect
       id="rect140"
       style="fill:#808080;fill-opacity:0.5;stroke:#000000;stroke-width:0"
       height="115"
       y="615"
       width="890.41302"
       x="1056.6497" />
    <rect
       id="rect142"
       style="fill:#808080;fill-opacity:0.5;stroke:#000000;stroke-width:0"
       height="115"
       y="165"
       width="668.16559"
       x="1281.8345" />
    <rect
       id="rect144"
       style="fill:#00ff00;fill-opacity:0.5;stroke:#000000;stroke-width:1"
       height="145"
       y="900"
       width="25.930164"
       x="1495.1" />
    <text
       id="text146"
       transform="matrix(0,1,-1,0,1501.1,904)">5_sd_probe_async</text>
    <text
       id="text148"
       transform="matrix(0,1,-1,0,0,89)">0.07</text>
    <text
       id="text150"
       transform="matrix(0,1,-1,0,130,89)">0.28</text>
    <text
       id="text152"
       transform="matrix(0,1,-1,0,260,89)">0.49</text>
    <text
       id="text154"
       transform="matrix(0,1,-1,0,390,89)">0.7</text>
    <text
       id="text156"
       transform="matrix(0,1,-1,0,520,89)">0.91</text>
    <text
       id="text158"
       transform="matrix(0,1,-1,0,650,89)">1.12</text>
    <text
       id="text160"
       transform="matrix(0,1,-1,0,780,89)">1.33</text>
    <text
       id="text162"
       transform="matrix(0,1,-1,0,910,89)">1.55</text>
    <text
       id="text164"
       transform="matrix(0,1,-1,0,1040,89)">1.76</text>
    <text
       id="text166"
       transform="matrix(0,1,-1,0,1170,89)">1.97</text>
    <text
       id="text168"
       transform="matrix(0,1,-1,0,1300,89)">2.18</text>
    <text
       id="text170"
       transform="matrix(0,1,-1,0,1430,89)">2.39</text>
    <text
       id="text172"
       transform="matrix(0,1,-1,0,1560,89)">2.6</text>
    <text
       id="text174"
       transform="matrix(0,1,-1,0,1690,89)">2.81</text>
    <text
       id="text176"
       transform="matrix(0,1,-1,0,1820,89)">3.02</text>
  </g>
</svg>

--=-5hiiqUwNgeHgNc1ewLxC--

