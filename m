Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab0BBPMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:12:07 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:46896 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab0BBPMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:12:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=gR/ivrkbx9k6B1XD5Qhn7QcKQfptEhN3qxVrV6X6PK3k0r0ajfeUrlwfzNWlzHqwNL
         R3cXL2xK1sC8TkwK2gqPJP06uhTobO3NmZEY5V7ffdEy2cF6SHpJzZxhTuphqxDAUagX
         bzAE8EbFeAhOU6AWAV2v0iZk3nNM+BT/xtCi8=
Date: Tue, 2 Feb 2010 16:11:56 +0100
From: Domenico Andreoli <cavokz@gmail.com>
To: Jerome Glisse <glisse@freedesktop.org>
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [crash, PATCH] Revert "drm/radeon/kms: move radeon KMS on/off
 switch out of staging."
Message-ID: <20100202151156.GB3992@raptus.dandreoli.com>
Mail-Followup-To: Jerome Glisse <glisse@freedesktop.org>,
	Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
	dri-devel@lists.sf.net
References: <alpine.DEB.2.00.1002010215530.15366@skynet.skynet.ie>
 <alpine.DEB.2.00.1002010253120.15366@skynet.skynet.ie>
 <20100202081727.GA6788@elte.hu>
 <20100202085820.GA9586@raptus.dandreoli.com>
 <20100202115913.GB10289@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202115913.GB10289@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 12:59:13PM +0100, Jerome Glisse wrote:
> On Tue, Feb 02, 2010 at 09:58:20AM +0100, Domenico Andreoli wrote:
> > 
> > boot broke also here where unfortunately i have not a serial line
> > to see what's happening. anyway disabling KMS restores a working
> > 2.6.33-rc6-00072-gab65832 kernel.  here is the broken config.
> 
> Can you boot in runlevel 3 and with radeon.modeset=0. Then modprobe radeon modeset=1
> (you might need to rmmod first), this should allow you capture dmesg log with the failure.
> (Do the modprobe/rmmod through ssh as you won't have a console in the process).

good, this is what I was missing to dig further into it.

> Note that here RV515 works like a charm :)

indeed it works also here :)

given that, I returned to my initial config, with radeon module built-in,
and re-enabled KMS. kernel was actually trying to load firmware blob
radeon/R520_cp.bin which no filesystem was ready to provide, idling for
60 long seconds and making me reporting a false bug. thank you for the
quick response.

[  113.133716] [drm] radeon kernel modesetting enabled.
[  113.133799] radeon 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  113.133842] radeon 0000:01:00.0: setting latency timer to 64
[  113.135000] [drm] radeon: Initializing kernel modesetting.
[  113.136538] [drm] register mmio base: 0xFE8E0000
[  113.136578] [drm] register mmio size: 65536
[  113.136659] ATOM BIOS: RV515LE
[  113.136906] [drm] GPU reset succeed (RBBM_STATUS=0x10000140)
[  113.136953] [drm] Generation 2 PCI interface, using max accessible memory
[  113.136993] [drm] radeon: VRAM 128M
[  113.137032] [drm] radeon: VRAM from 0x00000000 to 0x07FFFFFF
[  113.137071] [drm] radeon: GTT 512M
[  113.137109] [drm] radeon: GTT from 0x20000000 to 0x3FFFFFFF
[  113.137186] radeon 0000:01:00.0: irq 31 for MSI/MSI-X
[  113.137190] [drm] radeon: using MSI.
[  113.137246] [drm] radeon: irq initialized.
[  113.138965] [drm] Detected VRAM RAM=128M, BAR=256M
[  113.139007] [drm] RAM width 64bits DDR
[  113.139087] [TTM] Zone  kernel: Available graphics memory: 1028586 kiB.
[  113.139137] [drm] radeon: 128M of VRAM memory ready
[  113.139176] [drm] radeon: 512M of GTT memory ready.
[  113.139227] [drm] GART: num cpu pages 131072, num gpu pages 131072
[  113.141872] [drm] RB2D reset succeed (RBBM_STATUS=0x10000140)
[  113.141927] [drm] radeon: 1 quad pipes, 1 z pipes initialized.
[  113.142003] [drm] PCIE GART of 512M enabled (table at 0x00040000).
[  113.142050] [drm] radeon: cp idle (0x10000C03)
[  113.142115] [drm] Loading R500 Microcode
[  113.142158] platform radeon_cp.0: firmware: requesting radeon/R520_cp.bin
[  113.152774] [drm] radeon: ring at 0x0000000020000000
[  113.152846] [drm] ring test succeeded in 10 usecs
[  113.153249] [drm] radeon: ib pool ready.
[  113.153380] [drm] ib test succeeded in 0 usecs
[  113.153515] [drm] Default TV standard: PAL
[  113.153620] [drm] Radeon Display Connectors
[  113.153659] [drm] Connector 0:
[  113.153697] [drm]   VGA
[  113.153735] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[  113.153787] [drm]   Encoders:
[  113.153824] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[  113.153863] [drm] Connector 1:
[  113.153900] [drm]   S-video
[  113.153938] [drm]   Encoders:
[  113.153975] [drm]     TV1: INTERNAL_KLDSCP_DAC2
[  113.154014] [drm] Connector 2:
[  113.154051] [drm]   DVI-I
[  113.154088] [drm]   HPD2
[  113.154126] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[  113.154179] [drm]   Encoders:
[  113.154216] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[  113.154254] [drm]     DFP3: INTERNAL_LVTM1
[  113.204918] [drm:edid_is_valid] *ERROR* EDID checksum is invalid, remainder is 58
[  113.204968] [drm:edid_is_valid] *ERROR* Raw EDID:
[  113.205005] <3>00 ff ff ff ff ff ff 00 04 72 29 ad b5 04 20 45  .........r)... E
[  113.205006] <3>34 0e 01 03 68 26 1e 6b 2a c3 15 a4 59 4b a0 24  4...h&.k*...YK.$
[  113.205008] <3>14 4f 54 bf ef 00 81 8f 81 80 71 4f 71 40 61 4f  .OT.......qOq@aO
[  113.205009] <3>61 40 45 4f 45 40 30 2a 00 98 51 00 2a 40 30 70  a@EOE@0*..Q.*@0p
[  113.205010] <3>13 00 78 2d 11 00 00 1e 00 00 00 ff 00 45 54 4c  ..x-.........ETL
[  113.205012] <3>32 39 30 38 a0 00 31 0a 20 20 00 00 00 fd 00 37  2908..1.  .....7
[  113.205013] <3>4b 1e 53 0e 00 0a 20 20 20 20 20 20 00 00 00 fc  K.S...      ....
[  113.205014] <3>00 41 63 65 72 20 41 4c 31 39 31 32 0a 20 00 31  .Acer AL1912. .1
[  113.205015] 
[  113.255375] [drm:edid_is_valid] *ERROR* EDID checksum is invalid, remainder is 58
[  113.255425] [drm:edid_is_valid] *ERROR* Raw EDID:
[  113.255461] <3>00 ff ff ff ff ff ff 00 04 72 29 ad b5 04 20 45  .........r)... E
[  113.255462] <3>34 0e 01 03 68 26 1e 6b 2a c3 15 a4 59 4b a0 24  4...h&.k*...YK.$
[  113.255464] <3>14 4f 54 bf ef 00 81 8f 81 80 71 4f 71 40 61 4f  .OT.......qOq@aO
[  113.255465] <3>61 40 45 4f 45 40 30 2a 00 98 51 00 2a 40 30 70  a@EOE@0*..Q.*@0p
[  113.255466] <3>13 00 78 2d 11 00 00 1e 00 00 00 ff 00 45 54 4c  ..x-.........ETL
[  113.255467] <3>32 39 30 38 a0 00 31 0a 20 20 00 00 00 fd 00 37  2908..1.  .....7
[  113.255469] <3>4b 1e 53 0e 00 0a 20 20 20 20 20 20 00 00 00 fc  K.S...      ....
[  113.255470] <3>00 41 63 65 72 20 41 4c 31 39 31 32 0a 20 00 31  .Acer AL1912. .1
[  113.255471] 
[  113.305843] [drm:edid_is_valid] *ERROR* EDID checksum is invalid, remainder is 58
[  113.305892] [drm:edid_is_valid] *ERROR* Raw EDID:
[  113.305929] <3>00 ff ff ff ff ff ff 00 04 72 29 ad b5 04 20 45  .........r)... E
[  113.305930] <3>34 0e 01 03 68 26 1e 6b 2a c3 15 a4 59 4b a0 24  4...h&.k*...YK.$
[  113.305931] <3>14 4f 54 bf ef 00 81 8f 81 80 71 4f 71 40 61 4f  .OT.......qOq@aO
[  113.305933] <3>61 40 45 4f 45 40 30 2a 00 98 51 00 2a 40 30 70  a@EOE@0*..Q.*@0p
[  113.305934] <3>13 00 78 2d 11 00 00 1e 00 00 00 ff 00 45 54 4c  ..x-.........ETL
[  113.305935] <3>32 39 30 38 a0 00 31 0a 20 20 00 00 00 fd 00 37  2908..1.  .....7
[  113.305936] <3>4b 1e 53 0e 00 0a 20 20 20 20 20 20 00 00 00 fc  K.S...      ....
[  113.305938] <3>00 41 63 65 72 20 41 4c 31 39 31 32 0a 20 00 31  .Acer AL1912. .1
[  113.305939] 
[  113.356292] [drm:edid_is_valid] *ERROR* EDID checksum is invalid, remainder is 58
[  113.356342] [drm:edid_is_valid] *ERROR* Raw EDID:
[  113.356378] <3>00 ff ff ff ff ff ff 00 04 72 29 ad b5 04 20 45  .........r)... E
[  113.356379] <3>34 0e 01 03 68 26 1e 6b 2a c3 15 a4 59 4b a0 24  4...h&.k*...YK.$
[  113.356381] <3>14 4f 54 bf ef 00 81 8f 81 80 71 4f 71 40 61 4f  .OT.......qOq@aO
[  113.356382] <3>61 40 45 4f 45 40 30 2a 00 98 51 00 2a 40 30 70  a@EOE@0*..Q.*@0p
[  113.356383] <3>13 00 78 2d 11 00 00 1e 00 00 00 ff 00 45 54 4c  ..x-.........ETL
[  113.356385] <3>32 39 30 38 a0 00 31 0a 20 20 00 00 00 fd 00 37  2908..1.  .....7
[  113.356386] <3>4b 1e 53 0e 00 0a 20 20 20 20 20 20 00 00 00 fc  K.S...      ....
[  113.356387] <3>00 41 63 65 72 20 41 4c 31 39 31 32 0a 20 00 31  .Acer AL1912. .1
[  113.356388] 
[  113.356423] radeon 0000:01:00.0: VGA-1: EDID invalid.
[  113.421077] [drm:edid_is_valid] *ERROR* EDID checksum is invalid, remainder is 58
[  113.421127] [drm:edid_is_valid] *ERROR* Raw EDID:
[  113.421163] <3>00 ff ff ff ff ff ff 00 04 72 29 ad b5 04 20 45  .........r)... E
[  113.421164] <3>34 0e 01 03 68 26 1e 6b 2a c3 15 a4 59 4b a0 24  4...h&.k*...YK.$
[  113.421166] <3>14 4f 54 bf ef 00 81 8f 81 80 71 4f 71 40 61 4f  .OT.......qOq@aO
[  113.421167] <3>61 40 45 4f 45 40 30 2a 00 98 51 00 2a 40 30 70  a@EOE@0*..Q.*@0p
[  113.421168] <3>13 00 78 2d 11 00 00 1e 00 00 00 ff 00 45 54 4c  ..x-.........ETL
[  113.421170] <3>32 39 30 38 a0 00 31 0a 20 20 00 00 00 fd 00 37  2908..1.  .....7
[  113.421171] <3>4b 1e 53 0e 00 0a 20 20 20 20 20 20 00 00 00 fc  K.S...      ....
[  113.421172] <3>00 41 63 65 72 20 41 4c 31 39 31 32 0a 20 00 31  .Acer AL1912. .1
[  113.421173] 
[  113.471540] [drm:edid_is_valid] *ERROR* EDID checksum is invalid, remainder is 58
[  113.471589] [drm:edid_is_valid] *ERROR* Raw EDID:
[  113.471626] <3>00 ff ff ff ff ff ff 00 04 72 29 ad b5 04 20 45  .........r)... E
[  113.471627] <3>34 0e 01 03 68 26 1e 6b 2a c3 15 a4 59 4b a0 24  4...h&.k*...YK.$
[  113.471628] <3>14 4f 54 bf ef 00 81 8f 81 80 71 4f 71 40 61 4f  .OT.......qOq@aO
[  113.471629] <3>61 40 45 4f 45 40 30 2a 00 98 51 00 2a 40 30 70  a@EOE@0*..Q.*@0p
[  113.471631] <3>13 00 78 2d 11 00 00 1e 00 00 00 ff 00 45 54 4c  ..x-.........ETL
[  113.471632] <3>32 39 30 38 a0 00 31 0a 20 20 00 00 00 fd 00 37  2908..1.  .....7
[  113.471633] <3>4b 1e 53 0e 00 0a 20 20 20 20 20 20 00 00 00 fc  K.S...      ....
[  113.471634] <3>00 41 63 65 72 20 41 4c 31 39 31 32 0a 20 00 31  .Acer AL1912. .1
[  113.471635] 
[  113.521994] [drm:edid_is_valid] *ERROR* EDID checksum is invalid, remainder is 58
[  113.522044] [drm:edid_is_valid] *ERROR* Raw EDID:
[  113.522081] <3>00 ff ff ff ff ff ff 00 04 72 29 ad b5 04 20 45  .........r)... E
[  113.522082] <3>34 0e 01 03 68 26 1e 6b 2a c3 15 a4 59 4b a0 24  4...h&.k*...YK.$
[  113.522083] <3>14 4f 54 bf ef 00 81 8f 81 80 71 4f 71 40 61 4f  .OT.......qOq@aO
[  113.522084] <3>61 40 45 4f 45 40 30 2a 00 98 51 00 2a 40 30 70  a@EOE@0*..Q.*@0p
[  113.522086] <3>13 00 78 2d 11 00 00 1e 00 00 00 ff 00 45 54 4c  ..x-.........ETL
[  113.522087] <3>32 39 30 38 a0 00 31 0a 20 20 00 00 00 fd 00 37  2908..1.  .....7
[  113.522088] <3>4b 1e 53 0e 00 0a 20 20 20 20 20 20 00 00 00 fc  K.S...      ....
[  113.522090] <3>00 41 63 65 72 20 41 4c 31 39 31 32 0a 20 00 31  .Acer AL1912. .1
[  113.522090] 
[  113.572455] [drm:edid_is_valid] *ERROR* EDID checksum is invalid, remainder is 58
[  113.572514] [drm:edid_is_valid] *ERROR* Raw EDID:
[  113.572550] <3>00 ff ff ff ff ff ff 00 04 72 29 ad b5 04 20 45  .........r)... E
[  113.572552] <3>34 0e 01 03 68 26 1e 6b 2a c3 15 a4 59 4b a0 24  4...h&.k*...YK.$
[  113.572553] <3>14 4f 54 bf ef 00 81 8f 81 80 71 4f 71 40 61 4f  .OT.......qOq@aO
[  113.572554] <3>61 40 45 4f 45 40 30 2a 00 98 51 00 2a 40 30 70  a@EOE@0*..Q.*@0p
[  113.572555] <3>13 00 78 2d 11 00 00 1e 00 00 00 ff 00 45 54 4c  ..x-.........ETL
[  113.572557] <3>32 39 30 38 a0 00 31 0a 20 20 00 00 00 fd 00 37  2908..1.  .....7
[  113.572558] <3>4b 1e 53 0e 00 0a 20 20 20 20 20 20 00 00 00 fc  K.S...      ....
[  113.572559] <3>00 41 63 65 72 20 41 4c 31 39 31 32 0a 20 00 31  .Acer AL1912. .1
[  113.572560] 
[  113.572595] radeon 0000:01:00.0: VGA-1: EDID invalid.
[  113.572637] [drm:radeon_vga_detect] *ERROR* VGA-1: probed a monitor but no|invalid EDID
[  113.623019] [drm:edid_is_valid] *ERROR* EDID checksum is invalid, remainder is 58
[  113.623068] [drm:edid_is_valid] *ERROR* Raw EDID:
[  113.623105] <3>00 ff ff ff ff ff ff 00 04 72 29 ad b5 04 20 45  .........r)... E
[  113.623106] <3>34 0e 01 03 68 26 1e 6b 2a c3 15 a4 59 4b a0 24  4...h&.k*...YK.$
[  113.623107] <3>14 4f 54 bf ef 00 81 8f 81 80 71 4f 71 40 61 4f  .OT.......qOq@aO
[  113.623109] <3>61 40 45 4f 45 40 30 2a 00 98 51 00 2a 40 30 70  a@EOE@0*..Q.*@0p
[  113.623110] <3>13 00 78 2d 11 00 00 1e 00 00 00 ff 00 45 54 4c  ..x-.........ETL
[  113.623111] <3>32 39 30 38 a0 00 31 0a 20 20 00 00 00 fd 00 37  2908..1.  .....7
[  113.623113] <3>4b 1e 53 0e 00 0a 20 20 20 20 20 20 00 00 00 fc  K.S...      ....
[  113.623114] <3>00 41 63 65 72 20 41 4c 31 39 31 32 0a 20 00 31  .Acer AL1912. .1
[  113.623115] 
[  113.673495] [drm:edid_is_valid] *ERROR* EDID checksum is invalid, remainder is 58
[  113.673544] [drm:edid_is_valid] *ERROR* Raw EDID:
[  113.673581] <3>00 ff ff ff ff ff ff 00 04 72 29 ad b5 04 20 45  .........r)... E
[  113.673582] <3>34 0e 01 03 68 26 1e 6b 2a c3 15 a4 59 4b a0 24  4...h&.k*...YK.$
[  113.673583] <3>14 4f 54 bf ef 00 81 8f 81 80 71 4f 71 40 61 4f  .OT.......qOq@aO
[  113.673585] <3>61 40 45 4f 45 40 30 2a 00 98 51 00 2a 40 30 70  a@EOE@0*..Q.*@0p
[  113.673586] <3>13 00 78 2d 11 00 00 1e 00 00 00 ff 00 45 54 4c  ..x-.........ETL
[  113.673587] <3>32 39 30 38 a0 00 31 0a 20 20 00 00 00 fd 00 37  2908..1.  .....7
[  113.673588] <3>4b 1e 53 0e 00 0a 20 20 20 20 20 20 00 00 00 fc  K.S...      ....
[  113.673590] <3>00 41 63 65 72 20 41 4c 31 39 31 32 0a 20 00 31  .Acer AL1912. .1
[  113.673591] 
[  113.723964] [drm:edid_is_valid] *ERROR* EDID checksum is invalid, remainder is 58
[  113.724014] [drm:edid_is_valid] *ERROR* Raw EDID:
[  113.724050] <3>00 ff ff ff ff ff ff 00 04 72 29 ad b5 04 20 45  .........r)... E
[  113.724051] <3>34 0e 01 03 68 26 1e 6b 2a c3 15 a4 59 4b a0 24  4...h&.k*...YK.$
[  113.724053] <3>14 4f 54 bf ef 00 81 8f 81 80 71 4f 71 40 61 4f  .OT.......qOq@aO
[  113.724054] <3>61 40 45 4f 45 40 30 2a 00 98 51 00 2a 40 30 70  a@EOE@0*..Q.*@0p
[  113.724055] <3>13 00 78 2d 11 00 00 1e 00 00 00 ff 00 45 54 4c  ..x-.........ETL
[  113.724056] <3>32 39 30 38 a0 00 31 0a 20 20 00 00 00 fd 00 37  2908..1.  .....7
[  113.724058] <3>4b 1e 53 0e 00 0a 20 20 20 20 20 20 00 00 00 fc  K.S...      ....
[  113.724059] <3>00 41 63 65 72 20 41 4c 31 39 31 32 0a 20 00 31  .Acer AL1912. .1
[  113.724060] 
[  113.774428] [drm:edid_is_valid] *ERROR* EDID checksum is invalid, remainder is 58
[  113.774477] [drm:edid_is_valid] *ERROR* Raw EDID:
[  113.774513] <3>00 ff ff ff ff ff ff 00 04 72 29 ad b5 04 20 45  .........r)... E
[  113.774515] <3>34 0e 01 03 68 26 1e 6b 2a c3 15 a4 59 4b a0 24  4...h&.k*...YK.$
[  113.774516] <3>14 4f 54 bf ef 00 81 8f 81 80 71 4f 71 40 61 4f  .OT.......qOq@aO
[  113.774517] <3>61 40 45 4f 45 40 30 2a 00 98 51 00 2a 40 30 70  a@EOE@0*..Q.*@0p
[  113.774518] <3>13 00 78 2d 11 00 00 1e 00 00 00 ff 00 45 54 4c  ..x-.........ETL
[  113.774520] <3>32 39 30 38 a0 00 31 0a 20 20 00 00 00 fd 00 37  2908..1.  .....7
[  113.774521] <3>4b 1e 53 0e 00 0a 20 20 20 20 20 20 00 00 00 fc  K.S...      ....
[  113.774522] <3>00 41 63 65 72 20 41 4c 31 39 31 32 0a 20 00 31  .Acer AL1912. .1
[  113.774523] 
[  113.774558] radeon 0000:01:00.0: VGA-1: EDID invalid.
[  113.893751] [drm] fb mappable at 0xD00C0000
[  113.893790] [drm] vram apper at 0xD0000000
[  113.893828] [drm] size 3145728
[  113.893866] [drm] fb depth is 24
[  113.893903] [drm]    pitch is 4096
[  113.926724] Console: switching to colour frame buffer device 128x48
[  113.928980] fb0: radeondrmfb frame buffer device
[  113.929004] registered panic notifier
[  113.929024] [drm] Initialized radeon 2.0.0 20080528 for 0000:01:00.0 on minor 0

cheers,
Domenico

-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50
