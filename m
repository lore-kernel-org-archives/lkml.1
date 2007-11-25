Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbXKYQuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbXKYQuk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 11:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbXKYQua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 11:50:30 -0500
Received: from mx39.mail.ru ([194.67.23.35]:57685 "EHLO mx39.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbXKYQuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 11:50:18 -0500
X-Greylist: delayed 72804 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Nov 2007 11:50:15 EST
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: 2.6.24: Serial disabled in BIOS but serial modules still loaded (probably PnP related)
Date: Sun, 25 Nov 2007 19:50:05 +0300
User-Agent: KMail/1.9.7
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <200711242336.43712.arvidjaar@mail.ru> <86802c440711241509g6e80b49by67d40bb7d364580e@mail.gmail.com>
In-Reply-To: <86802c440711241509g6e80b49by67d40bb7d364580e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4086140.8zpSNHU8Od";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200711251950.06197.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4086140.8zpSNHU8Od
Content-Type: multipart/mixed;
  boundary="Boundary-01=_+eaSHugZpVwV/8S"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_+eaSHugZpVwV/8S
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 25 November 2007, Yinghai Lu wrote:
> On Nov 24, 2007 12:36 PM, Andrey Borzenkov <arvidjaar@mail.ru> wrote:
> > I have no COM port on notebook (without port replicator which I do not =
have)
> > so COM is disabled in BIOS. No ttyS* is detected during boot (and no de=
vice
> > created) but I just noticed that serial modules are still loaded. Well,=
 this
> > partially defeats the purpose of disabling COM port - the intention was=
 to
> > free resources by *not* loading unneeded modules ...
> >
> > This may have something to do with (ACPI) PnP which apparently believes=
 COM is alive.
> > Notebook is Toshiba Portege 4000.
> >
> > {pts/0}% lsmod | grep 82
> > 8250_pnp                9792  0
> > 8250                   24660  1 8250_pnp
> > serial_core            22872  1 8250
> >
> > {pts/0}% lspnp -v
> > 00:00 PNP0c01 System board
> >     state =3D active
> >         mem 0x0-0x9ffff
> >         mem 0xe0000-0xeffff
> >         mem 0xf0000-0xfffff
> >         mem 0x100000-0x1ef5ffff
> >
> > 00:01 PNP0a03 PCI bus
> >     state =3D active
> >         io 0xcf8-0xcff
> >
> > 00:02 PNP0200 AT DMA controller
> >     state =3D active
> >         io 0x0-0xf
> >         io 0x81-0x83
> >         io 0x87-0x87
> >         io 0x89-0x8b
> >         io 0x8f-0x8f
> >         io 0xc0-0xdf
> >         dma 4
> >
> > 00:03 PNP0800 AT speaker
> >     state =3D active
> >         io 0x61-0x61
> >
> > 00:04 PNP0c04 Math coprocessor
> >     state =3D active
> >         io 0xf0-0xff
> >         irq 13
> >
> > 00:05 PNP0303 IBM enhanced keyboard (101/102-key, PS/2 mouse support)
> >     state =3D active
> >         io 0x60-0x60
> >         io 0x64-0x64
> >         irq 1
> >
> > 00:06 PNP0f13 PS/2 port for PS/2-style mice
> >     state =3D active
> >         irq 12
> >
> > 00:07 PNP0b00 AT real-time clock
> >     state =3D active
> >         io 0x70-0x71
> >         irq 8
> >
> > 00:08 PNP0c02 Motherboard resources
> >     state =3D active
> >         io 0x2e-0x2f
> >         io 0x62-0x62
> >         io 0x66-0x66
> >         io 0x80-0x80
> >         io 0x84-0x86
> >         io 0x88-0x88
> >         io 0x8c-0x8e
> >         io 0x92-0x92
> >
> > 00:09 PNP0501 16550A-compatible serial port
> >     state =3D active
> >         io 0x3f8-0x3ff
> >         irq 5
> >
> > 00:0a SMCf010 SMC Fast Infrared Port
> >     state =3D disabled
> >
> > 00:0b PNP0401 ECP printer port
> >     state =3D disabled
> >
> > ..
> > [  126.035809] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ=
 sharing enabled
> ....
> > [  126.107096] serial 00:09: activated
> ....
>=20
> Can you cat /sys/firmware/acpi/DSDT and use iasl to decode it?
> it seems that your BIOS has problem about com setup.
>=20

DSDT attached.

To illustrate the problem. Here is what I get booting exactly the same kern=
el
with the only difference that COM is enabled in BIOS:

[  147.721790] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sha=
ring enabled
[  147.722658] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[  147.813557] 00:09: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A

When COM is disabled I get

[  235.865683] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sha=
ring enabled
[  236.221995] serial 00:09: activated

No ttyS0 - and it is correct.

I'd expect that either serial driver should not be loaded at all in this ca=
se.

--Boundary-01=_+eaSHugZpVwV/8S
Content-Type: text/x-objcsrc;
  charset="iso-8859-1";
  name="dsdt.dsl"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="dsdt.dsl"

/*
 * Intel ACPI Component Architecture
 * AML Disassembler version 20051216
 *
 * Disassembly of dsdt, Mon Mar  6 22:51:55 2006
 *
 * Original Table Header:
 *     Signature        "DSDT"
 *     Length           0x000068DA (26842)
 *     Revision         0x01
 *     OEM ID           "TOSHIB"
 *     OEM Table ID     "4000    "
 *     OEM Revision     0x20020417 (537003031)
 *     Creator ID       "MSFT"
 *     Creator Revision 0x0100000A (16777226)
 */
DefinitionBlock ("DSDT.aml", "DSDT", 1, "TOSHIB", "4000    ", 0x20020417)
{
    Name (\_S0, Package (0x04)
    {
        0x00,=20
        0x00,=20
        0x00,=20
        0x00
    })
    Name (\_S3, Package (0x04)
    {
        0x07,=20
        0x00,=20
        0x00,=20
        0x00
    })
    Name (\_S4, Package (0x04)
    {
        0x07,=20
        0x00,=20
        0x00,=20
        0x00
    })
    Name (\_S5, Package (0x04)
    {
        0x07,=20
        0x00,=20
        0x00,=20
        0x00
    })
    Scope (\_PR)
    {
        Processor (CPU0, 0x01, 0x0000EE10, 0x06)
        {
            Name (_PCT, Package (0x02)
            {
                ResourceTemplate ()
                {
                    Register (SystemIO,=20
                        0x08,               // Register Bit Width
                        0x00,               // Register Bit Offset
                        0x00000000000000B1, // Register Address
                        )
                },=20

                ResourceTemplate ()
                {
                    Register (SystemIO,=20
                        0x10,               // Register Bit Width
                        0x00,               // Register Bit Offset
                        0x000000000000EF40, // Register Address
                        )
                }
            })
            Method (_PSS, 0, NotSerialized)
            {
                If (\_SB.MEM.PSS1)
                {
                    Name (PSSD, Package (0x02)
                    {
                        Package (0x00) {},=20
                        Package (0x00) {}
                    })
                    Name (PSD0, Package (0x06)
                    {
                        0x03E8,=20
                        0x55F0,=20
                        0xFA,=20
                        0xFA,=20
                        0x90,=20
                        0x00
                    })
                    Name (PSD1, Package (0x06)
                    {
                        0x02BC,=20
                        0x2648,=20
                        0xFA,=20
                        0xFA,=20
                        0x91,=20
                        0x01
                    })
                    Store (\_SB.MEM.PSS0, Index (PSD0, 0x00))
                    Store (\_SB.MEM.PSS1, Index (PSD1, 0x00))
                    Store (PSD0, Index (PSSD, 0x00))
                    Store (PSD1, Index (PSSD, 0x01))
                    Return (PSSD)
                }
                Else
                {
                    Name (PSSC, Package (0x01)
                    {
                        Package (0x00) {}
                    })
                    Name (PSC0, Package (0x06)
                    {
                        0x03E8,=20
                        0x55F0,=20
                        0xFA,=20
                        0xFA,=20
                        0x90,=20
                        0x00
                    })
                    Store (\_SB.MEM.PSS0, Index (PSC0, 0x00))
                    Store (PSC0, Index (PSSC, 0x00))
                    Return (PSSC)
                }
            }

            Method (_PPC, 0, NotSerialized)
            {
                SMBR (0xFC00, 0x3D, 0x00, 0x00, 0xB2)
                And (\_SB.MEM.OECX, 0x03, Local0)
                If (LEqual (Local0, 0x00))
                {
                    If (\_SB.MEM.HPSU)
                    {
                        If (\_SB.MEM.ACST)
                        {
                            Return (\_SB.MEM.PULA)
                        }
                        Else
                        {
                            Return (\_SB.MEM.PULD)
                        }
                    }
                    Else
                    {
                        Return (0x00)
                    }
                }
                Else
                {
                    If (LEqual (Local0, 0x01))
                    {
                        Return (0x00)
                    }
                    Else
                    {
                        Return (0x01)
                    }
                }
            }
        }
    }

    Scope (\_SB)
    {
        Device (MEM)
        {
            Name (_HID, EisaId ("PNP0C01"))
            Name (_STA, 0x0F)
            Method (_CRS, 0, NotSerialized)
            {
                Return (CRS (0x01))
            }

            OperationRegion (SRAM, SystemMemory, 0x000EE800, 0x1800)
            Field (SRAM, AnyAcc, NoLock, Preserve)
            {
                PAR1,   16,=20
                PAR2,   16,=20
                PAR3,   16,=20
                PAR4,   16,=20
                PAR5,   16,=20
                PAR6,   16
            }

            Field (SRAM, AnyAcc, NoLock, Preserve)
            {
                Offset (0x02),=20
                RDID,   32,=20
                RDSN,   32,=20
                CAPB,   16
            }

            Field (SRAM, AnyAcc, NoLock, Preserve)
            {
                IEAX,   32,=20
                IEBX,   32,=20
                IECX,   32,=20
                IEDX,   32,=20
                IESI,   32,=20
                IEDI,   32,=20
                IEBP,   32,=20
                Offset (0x20),=20
                OEAX,   32,=20
                OEBX,   32,=20
                OECX,   32,=20
                OEDX,   32,=20
                OESI,   32,=20
                OEDI,   32,=20
                OEBP,   32,=20
                Offset (0xFF),=20
                ACST,   1,=20
                BES1,   1,=20
                BES2,   1,=20
                Offset (0x100),=20
                BMN1,   104,=20
                BSN1,   88,=20
                BTP1,   72,=20
                BPU1,   32,=20
                BDC1,   32,=20
                BLF1,   32,=20
                BTC1,   32,=20
                BDV1,   32,=20
                BST1,   32,=20
                BPR1,   32,=20
                BRC1,   32,=20
                BPV1,   32,=20
                Offset (0x149),=20
                BCW1,   32,=20
                BCL1,   32,=20
                BG11,   32,=20
                BG21,   32,=20
                BOI1,   8,=20
                BRF1,   1,=20
                Offset (0x200),=20
                BMN2,   104,=20
                BSN2,   88,=20
                BTP2,   72,=20
                BPU2,   32,=20
                BDC2,   32,=20
                BLF2,   32,=20
                BTC2,   32,=20
                BDV2,   32,=20
                BST2,   32,=20
                BPR2,   32,=20
                BRC2,   32,=20
                BPV2,   32,=20
                Offset (0x249),=20
                BCW2,   32,=20
                BCL2,   32,=20
                BG12,   32,=20
                BG22,   32,=20
                BOI2,   32,=20
                Offset (0x300),=20
                AC01,   16,=20
                AC11,   16,=20
                PSV1,   16,=20
                CRT1,   16,=20
                TMP1,   16,=20
                AST1,   16,=20
                AC21,   16,=20
                AC31,   16,=20
                AC02,   16,=20
                AC12,   16,=20
                PSV2,   16,=20
                CRT2,   16,=20
                TMP2,   16,=20
                AST2,   16,=20
                AC22,   16,=20
                AC32,   16,=20
                AC03,   16,=20
                AC13,   16,=20
                PSV3,   16,=20
                CRT3,   16,=20
                TMP3,   16,=20
                AST3,   16,=20
                AC23,   16,=20
                AC33,   16,=20
                Offset (0x340),=20
                TMPF,   16,=20
                Offset (0x3F0),=20
                FANH,   1,=20
                FANL,   7,=20
                TF11,   1,=20
                TF21,   1,=20
                TF31,   1,=20
                    ,   1,=20
                TF10,   1,=20
                TF20,   1,=20
                TF30,   1,=20
                Offset (0x3F2),=20
                TP11,   1,=20
                TP21,   1,=20
                TP31,   1,=20
                Offset (0x400),=20
                GP50,   1,=20
                GP51,   1,=20
                GP52,   1,=20
                GP53,   1,=20
                GP54,   1,=20
                Offset (0x401),=20
                GP60,   1,=20
                GP61,   1,=20
                GP62,   1,=20
                GP63,   1,=20
                GP64,   1,=20
                GP65,   1,=20
                GP66,   1,=20
                Offset (0x402),=20
                GP70,   1,=20
                GP71,   1,=20
                GP72,   1,=20
                GP73,   1,=20
                GP74,   1,=20
                GP75,   1,=20
                GP76,   1,=20
                GP77,   1,=20
                WED0,   1,=20
                WED1,   1,=20
                WED2,   1,=20
                WED3,   1,=20
                WED4,   1,=20
                Offset (0x404),=20
                SBL0,   1,=20
                SBL1,   1,=20
                SBL2,   1,=20
                SBL3,   1,=20
                Offset (0x405),=20
                LIDS,   1,=20
                VALF,   1,=20
                DCST,   1,=20
                DOS2,   1,=20
                DCKI,   1,=20
                DCKF,   1,=20
                BT1F,   1,=20
                BT2F,   1,=20
                NXLA,   1,=20
                NXCA,   1,=20
                NXTA,   1,=20
                NXDA,   1,=20
                CTLA,   1,=20
                CTCA,   1,=20
                CTTA,   1,=20
                CTDA,   1,=20
                LANA,   1,=20
                Offset (0x483),=20
                GCVS,   8,=20
                Offset (0x4C0),=20
                PSS0,   16,=20
                PSS1,   16,=20
                Offset (0x4D0),=20
                SYU0,   1,=20
                SYU1,   1,=20
                SYU2,   1,=20
                SYU3,   1,=20
                SYU4,   1,=20
                SYU5,   1,=20
                SYU6,   1,=20
                SYU7,   1,=20
                Offset (0x500),=20
                HKCD,   8,=20
                Offset (0x502),=20
                DLID,   32,=20
                DSRN,   32,=20
                Offset (0x50E),=20
                BDID,   32,=20
                DSPW,   1,=20
                VGAF,   1,=20
                VWE0,   1,=20
                VWE1,   1,=20
                PPSC,   1,=20
                SPSC,   1,=20
                EWLD,   1,=20
                EPWS,   1,=20
                LCDS,   4,=20
                CRTS,   4,=20
                VWE2,   1,=20
                WEF0,   1,=20
                WEF1,   1,=20
                WED5,   1,=20
                IEWE,   1,=20
                Offset (0x515),=20
                BTMD,   1,=20
                WSF0,   1,=20
                WSF1,   1,=20
                GP83,   1,=20
                WUIE,   1,=20
                    ,   1,=20
                BPFE,   1,=20
                BWUE,   1,=20
                DVIS,   4,=20
                Offset (0x517),=20
                HTM0,   1,=20
                HTM1,   1,=20
                Offset (0x518),=20
                PSND,   1,=20
                PMDM,   1,=20
                Offset (0x520),=20
                VGAR,   1,=20
                KBCR,   1,=20
                ID0R,   1,=20
                ID1R,   1,=20
                ID2R,   1,=20
                ID3R,   1,=20
                IDAR,   1,=20
                ACLR,   1,=20
                BTRE,   1,=20
                Offset (0x701),=20
                HAPS,   2,=20
                HHSW,   2,=20
                HPSU,   2,=20
                HRCU,   2,=20
                HGSU,   2,=20
                HEBI,   2,=20
                HTMD,   2,=20
                Offset (0x708),=20
                TNVS,   1,=20
                OSPC,   1,=20
                ACBK,   1,=20
                Offset (0x70A),=20
                PULD,   8,=20
                PULA,   8,=20
                BCLD,   8,=20
                BCLA,   8,=20
                Offset (0x710),=20
                OSID,   8,=20
                Offset (0x720),=20
                MSSI,   16,=20
                MSSS,   8,=20
                MSSR,   8,=20
                MSP0,   8,=20
                MSC0,   8,=20
                MSP1,   8,=20
                MSC1,   8,=20
                Offset (0x740),=20
                Offset (0x800),=20
                PRES,   32768
            }

            Field (SRAM, AnyAcc, NoLock, Preserve)
            {
                Offset (0x406),=20
                NXDD,   4,=20
                CTDD,   4
            }

            Field (SRAM, AnyAcc, NoLock, Preserve)
            {
                Offset (0x800),=20
                Offset (0x808),=20
                Offset (0x812),=20
                Offset (0x814),=20
                Offset (0x818),=20
                FSDP,   8,=20
                Offset (0x823),=20
                Offset (0x826),=20
                Offset (0x836),=20
                Offset (0x87E),=20
                Offset (0x87F),=20
                EDCK,   8
            }
        }

        Device (PCI0)
        {
            Name (_HID, EisaId ("PNP0A03"))
            Name (_ADR, 0x00)
            Name (_CRS, ResourceTemplate ()
            {
                WordBusNumber (ResourceProducer, MinFixed, MaxFixed, PosDec=
ode,
                    0x0000,             // Address Space Granularity
                    0x0000,             // Address Range Minimum
                    0x00FF,             // Address Range Maximum
                    0x0000,             // Address Translation Offset
                    0x0100,             // Address Length
                    ,,)
                IO (Decode16,
                    0x0CF8,             // Address Range Minimum
                    0x0CF8,             // Address Range Maximum
                    0x01,               // Address Alignment
                    0x08,               // Address Length
                    )
                WordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, En=
tireRange,
                    0x0000,             // Address Space Granularity
                    0x0000,             // Address Range Minimum
                    0x0CF7,             // Address Range Maximum
                    0x0000,             // Address Translation Offset
                    0x0CF8,             // Address Length
                    ,,, TypeStatic)
                WordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, En=
tireRange,
                    0x0000,             // Address Space Granularity
                    0x0D00,             // Address Range Minimum
                    0xFFFF,             // Address Range Maximum
                    0x0000,             // Address Translation Offset
                    0xF300,             // Address Length
                    ,,, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixe=
d, NonCacheable, ReadWrite,
                    0x00000000,         // Address Space Granularity
                    0x000A0000,         // Address Range Minimum
                    0x000BFFFF,         // Address Range Maximum
                    0x00000000,         // Address Translation Offset
                    0x00020000,         // Address Length
                    ,,, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixe=
d, NonCacheable, ReadWrite,
                    0x00000000,         // Address Space Granularity
                    0x000D8000,         // Address Range Minimum
                    0x000DFFFF,         // Address Range Maximum
                    0x00000000,         // Address Translation Offset
                    0x00008000,         // Address Length
                    ,,, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixe=
d, NonCacheable, ReadWrite,
                    0x00000000,         // Address Space Granularity
                    0x40100000,         // Address Range Minimum
                    0xFEE9FFFF,         // Address Range Maximum
                    0x00000000,         // Address Translation Offset
                    0xBEEA0000,         // Address Length
                    ,,, AddressRangeMemory, TypeStatic)
            })
            Name (_PRT, Package (0x0A)
            {
                Package (0x04)
                {
                    0x0014FFFF,=20
                    0x00,=20
                    \_SB.PCI0.FNC0.LNKD,=20
                    0x00
                },=20

                Package (0x04)
                {
                    0x0011FFFF,=20
                    0x00,=20
                    \_SB.PCI0.FNC0.LNKA,=20
                    0x00
                },=20

                Package (0x04)
                {
                    0x0011FFFF,=20
                    0x01,=20
                    \_SB.PCI0.FNC0.LNKB,=20
                    0x00
                },=20

                Package (0x04)
                {
                    0x000AFFFF,=20
                    0x00,=20
                    \_SB.PCI0.FNC0.LNKD,=20
                    0x00
                },=20

                Package (0x04)
                {
                    0x0010FFFF,=20
                    0x00,=20
                    \_SB.PCI0.FNC0.LNKC,=20
                    0x00
                },=20

                Package (0x04)
                {
                    0x0010FFFF,=20
                    0x01,=20
                    \_SB.PCI0.FNC0.LNKD,=20
                    0x00
                },=20

                Package (0x04)
                {
                    0x000CFFFF,=20
                    0x00,=20
                    \_SB.PCI0.FNC0.LNKD,=20
                    0x00
                },=20

                Package (0x04)
                {
                    0x0006FFFF,=20
                    0x00,=20
                    \_SB.PCI0.FNC0.LNKH,=20
                    0x00
                },=20

                Package (0x04)
                {
                    0x0012FFFF,=20
                    0x00,=20
                    \_SB.PCI0.FNC0.LNKA,=20
                    0x00
                },=20

                Package (0x04)
                {
                    0x0002FFFF,=20
                    0x00,=20
                    \_SB.PCI0.FNC0.LNKG,=20
                    0x00
                }
            })
            Device (FNC0)
            {
                Name (_ADR, 0x00070000)
                OperationRegion (M153, PCI_Config, 0x00, 0xFF)
                Field (M153, ByteAcc, NoLock, Preserve)
                {
                    Offset (0x44),=20
                    IRQJ,   4,=20
                        ,   3,=20
                    RSTC,   1,=20
                    Offset (0x48),=20
                    IRQA,   4,=20
                    IRQB,   4,=20
                    IRQC,   4,=20
                    IRQD,   4,=20
                    IRQE,   4,=20
                    IRQF,   4,=20
                    IRQI,   4,=20
                    IRQH,   4,=20
                    Offset (0x52),=20
                        ,   13,=20
                    CUS1,   1,=20
                    Offset (0x74),=20
                    IRQG,   4,=20
                    Offset (0x75),=20
                    IRQK,   4,=20
                    Offset (0x77),=20
                        ,   3,=20
                    CSND,   1,=20
                        ,   1,=20
                    CMDM,   1
                }

                Device (LNKA)
                {
                    Name (_HID, EisaId ("PNP0C0F"))
                    Name (_UID, 0x01)
                    Method (_STA, 0, NotSerialized)
                    {
                        Return (STAL (\_SB.PCI0.FNC0.IRQA))
                    }

                    Name (_PRS, ResourceTemplate ()
                    {
                        IRQ (Level, ActiveLow, Shared)
                            {3,4,5,6,7,10,11}
                    })
                    Method (_CRS, 0, NotSerialized)
                    {
                        Return (CRSL (\_SB.PCI0.FNC0.IRQA))
                    }

                    Method (_DIS, 0, NotSerialized)
                    {
                        Store (0x00, \_SB.PCI0.FNC0.IRQA)
                    }

                    Method (_SRS, 1, NotSerialized)
                    {
                        Name (IRQT, Package (0x10)
                        {
                            0x00,=20
                            0x08,=20
                            0x00,=20
                            0x02,=20
                            0x04,=20
                            0x05,=20
                            0x07,=20
                            0x06,=20
                            0x00,=20
                            0x01,=20
                            0x03,=20
                            0x09,=20
                            0x0B,=20
                            0x00,=20
                            0x0D,=20
                            0x0F
                        })
                        CreateWordField (Arg0, 0x01, IRQX)
                        FindSetRightBit (IRQX, Local0)
                        Decrement (Local0)
                        Store (DerefOf (Index (IRQT, Local0)), Local1)
                        Store (Local1, \_SB.PCI0.FNC0.IRQA)
                    }
                }

                Device (LNKB)
                {
                    Name (_HID, EisaId ("PNP0C0F"))
                    Name (_UID, 0x02)
                    Method (_STA, 0, NotSerialized)
                    {
                        Return (STAL (\_SB.PCI0.FNC0.IRQB))
                    }

                    Name (_PRS, ResourceTemplate ()
                    {
                        IRQ (Level, ActiveLow, Shared)
                            {3,4,5,6,7,10,11}
                    })
                    Method (_CRS, 0, NotSerialized)
                    {
                        Return (CRSL (\_SB.PCI0.FNC0.IRQB))
                    }

                    Method (_DIS, 0, NotSerialized)
                    {
                        Store (0x00, \_SB.PCI0.FNC0.IRQB)
                    }

                    Method (_SRS, 1, NotSerialized)
                    {
                        Name (IRQT, Package (0x10)
                        {
                            0x00,=20
                            0x08,=20
                            0x00,=20
                            0x02,=20
                            0x04,=20
                            0x05,=20
                            0x07,=20
                            0x06,=20
                            0x00,=20
                            0x01,=20
                            0x03,=20
                            0x09,=20
                            0x0B,=20
                            0x00,=20
                            0x0D,=20
                            0x0F
                        })
                        CreateWordField (Arg0, 0x01, IRQX)
                        FindSetRightBit (IRQX, Local0)
                        Decrement (Local0)
                        Store (DerefOf (Index (IRQT, Local0)), Local1)
                        Store (Local1, \_SB.PCI0.FNC0.IRQB)
                    }
                }

                Device (LNKC)
                {
                    Name (_HID, EisaId ("PNP0C0F"))
                    Name (_UID, 0x03)
                    Method (_STA, 0, NotSerialized)
                    {
                        Return (STAL (\_SB.PCI0.FNC0.IRQC))
                    }

                    Name (_PRS, ResourceTemplate ()
                    {
                        IRQ (Level, ActiveLow, Shared)
                            {3,4,5,6,7,10,11}
                    })
                    Method (_CRS, 0, NotSerialized)
                    {
                        Return (CRSL (\_SB.PCI0.FNC0.IRQC))
                    }

                    Method (_DIS, 0, NotSerialized)
                    {
                        Store (0x00, \_SB.PCI0.FNC0.IRQC)
                    }

                    Method (_SRS, 1, NotSerialized)
                    {
                        Name (IRQT, Package (0x10)
                        {
                            0x00,=20
                            0x08,=20
                            0x00,=20
                            0x02,=20
                            0x04,=20
                            0x05,=20
                            0x07,=20
                            0x06,=20
                            0x00,=20
                            0x01,=20
                            0x03,=20
                            0x09,=20
                            0x0B,=20
                            0x00,=20
                            0x0D,=20
                            0x0F
                        })
                        CreateWordField (Arg0, 0x01, IRQX)
                        FindSetRightBit (IRQX, Local0)
                        Decrement (Local0)
                        Store (DerefOf (Index (IRQT, Local0)), Local1)
                        Store (Local1, \_SB.PCI0.FNC0.IRQC)
                    }
                }

                Device (LNKD)
                {
                    Name (_HID, EisaId ("PNP0C0F"))
                    Name (_UID, 0x04)
                    Method (_STA, 0, NotSerialized)
                    {
                        Return (STAL (\_SB.PCI0.FNC0.IRQD))
                    }

                    Name (_PRS, ResourceTemplate ()
                    {
                        IRQ (Level, ActiveLow, Shared)
                            {3,4,5,6,7,10,11}
                    })
                    Method (_CRS, 0, NotSerialized)
                    {
                        Return (CRSL (\_SB.PCI0.FNC0.IRQD))
                    }

                    Method (_DIS, 0, NotSerialized)
                    {
                        Store (0x00, \_SB.PCI0.FNC0.IRQD)
                    }

                    Method (_SRS, 1, NotSerialized)
                    {
                        Name (IRQT, Package (0x10)
                        {
                            0x00,=20
                            0x08,=20
                            0x00,=20
                            0x02,=20
                            0x04,=20
                            0x05,=20
                            0x07,=20
                            0x06,=20
                            0x00,=20
                            0x01,=20
                            0x03,=20
                            0x09,=20
                            0x0B,=20
                            0x00,=20
                            0x0D,=20
                            0x0F
                        })
                        CreateWordField (Arg0, 0x01, IRQX)
                        FindSetRightBit (IRQX, Local0)
                        Decrement (Local0)
                        Store (DerefOf (Index (IRQT, Local0)), Local1)
                        Store (Local1, \_SB.PCI0.FNC0.IRQD)
                    }
                }

                Device (LNKG)
                {
                    Name (_HID, EisaId ("PNP0C0F"))
                    Name (_UID, 0x07)
                    Method (_STA, 0, NotSerialized)
                    {
                        Return (STAL (\_SB.PCI0.FNC0.IRQG))
                    }

                    Name (_PRS, ResourceTemplate ()
                    {
                        IRQ (Level, ActiveLow, Shared)
                            {3,4,5,6,7,10,11}
                    })
                    Method (_CRS, 0, NotSerialized)
                    {
                        Return (CRSL (\_SB.PCI0.FNC0.IRQG))
                    }

                    Method (_DIS, 0, NotSerialized)
                    {
                        Store (0x00, \_SB.PCI0.FNC0.IRQG)
                    }

                    Method (_SRS, 1, NotSerialized)
                    {
                        Name (IRQT, Package (0x10)
                        {
                            0x00,=20
                            0x08,=20
                            0x00,=20
                            0x02,=20
                            0x04,=20
                            0x05,=20
                            0x07,=20
                            0x06,=20
                            0x00,=20
                            0x01,=20
                            0x03,=20
                            0x09,=20
                            0x0B,=20
                            0x00,=20
                            0x0D,=20
                            0x0F
                        })
                        CreateWordField (Arg0, 0x01, IRQX)
                        FindSetRightBit (IRQX, Local0)
                        Decrement (Local0)
                        Store (DerefOf (Index (IRQT, Local0)), Local1)
                        Store (Local1, \_SB.PCI0.FNC0.IRQG)
                    }
                }

                Device (LNKH)
                {
                    Name (_HID, EisaId ("PNP0C0F"))
                    Name (_UID, 0x08)
                    Method (_STA, 0, NotSerialized)
                    {
                        Return (STAL (\_SB.PCI0.FNC0.IRQH))
                    }

                    Name (_PRS, ResourceTemplate ()
                    {
                        IRQ (Level, ActiveLow, Shared)
                            {3,4,5,6,7,10,11}
                    })
                    Method (_CRS, 0, NotSerialized)
                    {
                        Return (CRSL (\_SB.PCI0.FNC0.IRQH))
                    }

                    Method (_DIS, 0, NotSerialized)
                    {
                        Store (0x00, \_SB.PCI0.FNC0.IRQH)
                    }

                    Method (_SRS, 1, NotSerialized)
                    {
                        Name (IRQT, Package (0x10)
                        {
                            0x00,=20
                            0x08,=20
                            0x00,=20
                            0x02,=20
                            0x04,=20
                            0x05,=20
                            0x07,=20
                            0x06,=20
                            0x00,=20
                            0x01,=20
                            0x03,=20
                            0x09,=20
                            0x0B,=20
                            0x00,=20
                            0x0D,=20
                            0x0F
                        })
                        CreateWordField (Arg0, 0x01, IRQX)
                        FindSetRightBit (IRQX, Local0)
                        Decrement (Local0)
                        Store (DerefOf (Index (IRQT, Local0)), Local1)
                        Store (Local1, \_SB.PCI0.FNC0.IRQH)
                    }
                }

                Device (DMAC)
                {
                    Name (_HID, EisaId ("PNP0200"))
                    Name (_STA, 0x0F)
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0000,             // Address Range Minimum
                            0x0000,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x10,               // Address Length
                            )
                        IO (Decode16,
                            0x0081,             // Address Range Minimum
                            0x0081,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x03,               // Address Length
                            )
                        IO (Decode16,
                            0x0087,             // Address Range Minimum
                            0x0087,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x01,               // Address Length
                            )
                        IO (Decode16,
                            0x0089,             // Address Range Minimum
                            0x0089,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x03,               // Address Length
                            )
                        IO (Decode16,
                            0x008F,             // Address Range Minimum
                            0x008F,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x01,               // Address Length
                            )
                        IO (Decode16,
                            0x00C0,             // Address Range Minimum
                            0x00C0,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x20,               // Address Length
                            )
                        DMA (Compatibility, NotBusMaster, Transfer8)
                            {4}
                    })
                }

                Device (PIC)
                {
                    Name (_HID, EisaId ("PNP0000"))
                    Name (_STA, 0x0F)
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0020,             // Address Range Minimum
                            0x0020,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x02,               // Address Length
                            )
                        IO (Decode16,
                            0x00A0,             // Address Range Minimum
                            0x00A0,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x02,               // Address Length
                            )
                        IRQ (Edge, ActiveHigh, Exclusive)
                            {2}
                    })
                }

                Device (PIT)
                {
                    Name (_HID, EisaId ("PNP0100"))
                    Name (_STA, 0x0F)
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0040,             // Address Range Minimum
                            0x0040,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x04,               // Address Length
                            )
                        IRQ (Edge, ActiveHigh, Exclusive)
                            {0}
                    })
                }

                Device (SPKR)
                {
                    Name (_HID, EisaId ("PNP0800"))
                    Name (_STA, 0x0F)
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0061,             // Address Range Minimum
                            0x0061,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x01,               // Address Length
                            )
                    })
                }

                Device (NDP)
                {
                    Name (_HID, EisaId ("PNP0C04"))
                    Name (_STA, 0x0F)
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x00F0,             // Address Range Minimum
                            0x00F0,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x10,               // Address Length
                            )
                        IRQ (Edge, ActiveHigh, Shared)
                            {13}
                    })
                }

                Device (KBC)
                {
                    Name (_HID, EisaId ("PNP0303"))
                    Method (_STA, 0, NotSerialized)
                    {
                        While (LEqual (\_SB.MEM.KBCR, 0x00)) {}
                        Return (0x0F)
                    }

                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0060,             // Address Range Minimum
                            0x0060,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x01,               // Address Length
                            )
                        IO (Decode16,
                            0x0064,             // Address Range Minimum
                            0x0064,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x01,               // Address Length
                            )
                        IRQ (Edge, ActiveHigh, Exclusive)
                            {1}
                    })
                }

                Device (PS2M)
                {
                    Name (_HID, EisaId ("PNP0F13"))
                    Method (_STA, 0, NotSerialized)
                    {
                        While (LEqual (\_SB.MEM.KBCR, 0x00)) {}
                        Return (0x0F)
                    }

                    Name (_CRS, ResourceTemplate ()
                    {
                        IRQ (Edge, ActiveHigh, Exclusive)
                            {12}
                    })
                }

                Device (RTC)
                {
                    Name (_HID, EisaId ("PNP0B00"))
                    Name (_STA, 0x0F)
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0070,             // Address Range Minimum
                            0x0070,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x02,               // Address Length
                            )
                        IRQ (Edge, ActiveHigh, Exclusive)
                            {8}
                    })
                }

                Device (SYSR)
                {
                    Name (_HID, EisaId ("PNP0C02"))
                    Name (_STA, 0x0F)
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x002E,             // Address Range Minimum
                            0x002E,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x02,               // Address Length
                            )
                        IO (Decode16,
                            0x0062,             // Address Range Minimum
                            0x0062,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x01,               // Address Length
                            )
                        IO (Decode16,
                            0x0066,             // Address Range Minimum
                            0x0066,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x01,               // Address Length
                            )
                        IO (Decode16,
                            0x0080,             // Address Range Minimum
                            0x0080,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x01,               // Address Length
                            )
                        IO (Decode16,
                            0x0084,             // Address Range Minimum
                            0x0084,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x03,               // Address Length
                            )
                        IO (Decode16,
                            0x0088,             // Address Range Minimum
                            0x0088,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x01,               // Address Length
                            )
                        IO (Decode16,
                            0x008C,             // Address Range Minimum
                            0x008C,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x03,               // Address Length
                            )
                        IO (Decode16,
                            0x0092,             // Address Range Minimum
                            0x0092,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x01,               // Address Length
                            )
                        IO (Decode16,
                            0x00B0,             // Address Range Minimum
                            0x00B0,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x04,               // Address Length
                            )
                        IO (Decode16,
                            0x00E0,             // Address Range Minimum
                            0x00E0,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x10,               // Address Length
                            )
                        IO (Decode16,
                            0x0370,             // Address Range Minimum
                            0x0370,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x02,               // Address Length
                            )
                        IO (Decode16,
                            0x040B,             // Address Range Minimum
                            0x040B,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x01,               // Address Length
                            )
                        IO (Decode16,
                            0x0480,             // Address Range Minimum
                            0x0480,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x10,               // Address Length
                            )
                        IO (Decode16,
                            0x04D0,             // Address Range Minimum
                            0x04D0,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x02,               // Address Length
                            )
                        IO (Decode16,
                            0x04D6,             // Address Range Minimum
                            0x04D6,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x01,               // Address Length
                            )
                        IO (Decode16,
                            0x06C0,             // Address Range Minimum
                            0x06C0,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x40,               // Address Length
                            )
                        IO (Decode16,
                            0xE000,             // Address Range Minimum
                            0xE000,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x80,               // Address Length
                            )
                        IO (Decode16,
                            0xE080,             // Address Range Minimum
                            0xE080,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x80,               // Address Length
                            )
                        IO (Decode16,
                            0xE400,             // Address Range Minimum
                            0xE400,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x80,               // Address Length
                            )
                        IO (Decode16,
                            0xE480,             // Address Range Minimum
                            0xE480,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x80,               // Address Length
                            )
                        IO (Decode16,
                            0xE800,             // Address Range Minimum
                            0xE800,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x80,               // Address Length
                            )
                        IO (Decode16,
                            0xE880,             // Address Range Minimum
                            0xE880,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x80,               // Address Length
                            )
                        IO (Decode16,
                            0xEC00,             // Address Range Minimum
                            0xEC00,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x80,               // Address Length
                            )
                        IO (Decode16,
                            0xEC80,             // Address Range Minimum
                            0xEC80,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x80,               // Address Length
                            )
                        IO (Decode16,
                            0xEE00,             // Address Range Minimum
                            0xEE00,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x42,               // Address Length
                            )
                        IO (Decode16,
                            0xEE90,             // Address Range Minimum
                            0xEE90,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x10,               // Address Length
                            )
                        IO (Decode16,
                            0xEEAC,             // Address Range Minimum
                            0xEEAC,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x01,               // Address Length
                            )
                        IO (Decode16,
                            0xEF00,             // Address Range Minimum
                            0xEF00,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x40,               // Address Length
                            )
                        IO (Decode16,
                            0xEF40,             // Address Range Minimum
                            0xEF40,             // Address Range Maximum
                            0x01,               // Address Alignment
                            0x20,               // Address Length
                            )
                    })
                    OperationRegion (SRG1, SystemIO, 0xB1, 0x01)
                    Field (SRG1, ByteAcc, NoLock, Preserve)
                    {
                        TRP4,   8
                    }
                }

                Device (COM)
                {
                    Name (_HID, EisaId ("PNP0501"))
                    Method (_STA, 0, NotSerialized)
                    {
                        Return (STA (0x0E))
                    }

                    Method (_CRS, 0, NotSerialized)
                    {
                        Return (CRS (0x0E))
                    }

                    Method (_PRS, 0, NotSerialized)
                    {
                        Return (PRS (0x0E))
                    }

                    Method (_SRS, 1, NotSerialized)
                    {
                        SRS (0x0E, Arg0)
                    }

                    Method (_DIS, 0, NotSerialized)
                    {
                        DIS (0x0E)
                    }

                    Method (_PS0, 0, NotSerialized)
                    {
                        PS0 (0x0E)
                    }

                    Method (_PS3, 0, NotSerialized)
                    {
                        PS3 (0x0E)
                    }

                    Method (_PSC, 0, NotSerialized)
                    {
                        Return (PSC (0x0E))
                    }

                    Name (_PRW, Package (0x02)
                    {
                        0x08,=20
                        0x03
                    })
                    Method (_PSW, 1, NotSerialized)
                    {
                        Store (Arg0, \_SB.MEM.WED0)
                    }
                }

                Device (FSIR)
                {
                    Name (_HID, EisaId ("SMCF010"))
                    Method (_STA, 0, NotSerialized)
                    {
                        Return (STA (0x0F))
                    }

                    Method (_CRS, 0, NotSerialized)
                    {
                        Return (CRS (0x0F))
                    }

                    Method (_PRS, 0, NotSerialized)
                    {
                        Return (PRS (0x0F))
                    }

                    Method (_SRS, 1, NotSerialized)
                    {
                        SRS (0x0F, Arg0)
                    }

                    Method (_DIS, 0, NotSerialized)
                    {
                        DIS (0x0F)
                    }
                }

                Device (PRT)
                {
                    Name (_HID, EisaId ("PNP0401"))
                    Method (_STA, 0, NotSerialized)
                    {
                        Return (STA (0x10))
                    }

                    Method (_CRS, 0, NotSerialized)
                    {
                        Return (CRS (0x10))
                    }

                    Method (_PRS, 0, NotSerialized)
                    {
                        Return (PRS (0x10))
                    }

                    Method (_SRS, 1, NotSerialized)
                    {
                        SRS (0x10, Arg0)
                    }

                    Method (_DIS, 0, NotSerialized)
                    {
                        DIS (0x10)
                    }
                }

                Device (PRT1)
                {
                    Name (_HID, EisaId ("PNP0400"))
                    Method (_STA, 0, NotSerialized)
                    {
                        Return (STA (0x12))
                    }

                    Method (_CRS, 0, NotSerialized)
                    {
                        Return (CRS (0x12))
                    }

                    Method (_PRS, 0, NotSerialized)
                    {
                        Return (PRS (0x12))
                    }

                    Method (_SRS, 1, NotSerialized)
                    {
                        SRS (0x12, Arg0)
                    }

                    Method (_DIS, 0, NotSerialized)
                    {
                        DIS (0x12)
                    }
                }

                Device (PCC0)
                {
                    Name (_HID, EisaId ("PNP0E00"))
                    Name (_UID, 0x01)
                    Method (_STA, 0, NotSerialized)
                    {
                        Return (STA (0x13))
                    }

                    Method (_CRS, 0, NotSerialized)
                    {
                        Return (CRS (0x13))
                    }

                    Method (_PRS, 0, NotSerialized)
                    {
                        Return (PRS (0x13))
                    }

                    Method (_SRS, 1, NotSerialized)
                    {
                        SRS (0x13, Arg0)
                    }

                    Method (_DIS, 0, NotSerialized)
                    {
                        DIS (0x13)
                    }

                    Name (_PRW, Package (0x02)
                    {
                        0x09,=20
                        0x03
                    })
                    Method (_PSW, 1, NotSerialized)
                    {
                        Store (Arg0, \_SB.MEM.WED2)
                    }

                    Device (PCS0)
                    {
                        Name (_ADR, 0x00)
                        Name (_SUN, 0x00)
                    }

                    Device (PCS1)
                    {
                        Name (_ADR, 0x01)
                        Name (_SUN, 0x01)
                    }
                }

                Device (ATA)
                {
                    Name (_HID, EisaId ("PNP0600"))
                    Name (_UID, 0x03)
                    Method (_STA, 0, NotSerialized)
                    {
                        Return (STA (0x16))
                    }

                    Method (_CRS, 0, NotSerialized)
                    {
                        Return (CRS (0x16))
                    }

                    Method (_PRS, 0, NotSerialized)
                    {
                        Return (PRS (0x16))
                    }

                    Method (_SRS, 1, NotSerialized)
                    {
                        SRS (0x16, Arg0)
                    }

                    Method (_DIS, 0, NotSerialized)
                    {
                        DIS (0x16)
                    }
                }
            }

            Device (FNC1)
            {
                Name (_ADR, 0x00040000)
                OperationRegion (IDEC, PCI_Config, 0x00, 0xFF)
                Field (IDEC, ByteAcc, NoLock, Preserve)
                {
                    Offset (0x54),=20
                    FTHP,   4,=20
                    Offset (0x55),=20
                    FTHS,   4,=20
                    Offset (0x56),=20
                    PUDS,   4,=20
                    Offset (0x57),=20
                    SUDS,   4,=20
                    Offset (0x58),=20
                    PAST,   3,=20
                    Offset (0x59),=20
                    PCRC,   4,=20
                    PCAC,   3,=20
                    Offset (0x5A),=20
                    PDRC,   4,=20
                    PDAC,   3,=20
                    Offset (0x5C),=20
                    SAST,   3,=20
                    Offset (0x5D),=20
                    SCRC,   4,=20
                    SCAC,   3,=20
                    Offset (0x5E),=20
                    SDRC,   4,=20
                    SDAC,   3
                }

                Device (IDE0)
                {
                    Name (_ADR, 0x00)
                    Method (_STA, 0, NotSerialized)
                    {
                        Return (0x0F)
                    }

                    Method (_PS0, 0, NotSerialized)
                    {
                        While (LEqual (\_SB.MEM.ID0R, 0x00)) {}
                        Store (0x00, \_SB.MEM.PPSC)
                    }

                    Method (_PS3, 0, NotSerialized)
                    {
                        While (LEqual (\_SB.MEM.ID0R, 0x00)) {}
                        Store (0x01, \_SB.MEM.PPSC)
                    }

                    Method (_PSC, 0, NotSerialized)
                    {
                        While (LEqual (\_SB.MEM.ID0R, 0x00)) {}
                        If (\_SB.MEM.PPSC)
                        {
                            Return (0x03)
                        }
                        Else
                        {
                            Return (0x00)
                        }
                    }

                    Method (_STM, 3, NotSerialized)
                    {
                        While (LEqual (\_SB.MEM.ID0R, 0x00)) {}
                        Store (0x01, \_SB.MEM.HTM0)
                        CreateDWordField (Arg0, 0x00, PPIO)
                        CreateDWordField (Arg0, 0x04, PDMA)
                        CreateDWordField (Arg0, 0x10, PFLG)
                        Store (PPIO, Local0)
                        Store (0x03, Local1)
                        Store (0x0A, Local2)
                        Store (0x00, Local3)
                        Store (0x08, Local4)
                        Store (0x08, Local5)
                        If (LNot (LGreater (Local0, 0x78)))
                        {
                            Store (0x02, Local1)
                            Store (0x01, Local2)
                            Store (0x03, Local3)
                            Store (0x01, Local4)
                            Store (0x03, Local5)
                        }
                        Else
                        {
                            If (LNot (LGreater (Local0, 0xB4)))
                            {
                                Store (0x02, Local1)
                                Store (0x03, Local2)
                                Store (0x03, Local3)
                                Store (0x03, Local4)
                                Store (0x03, Local5)
                            }
                            Else
                            {
                                If (LNot (LGreater (Local0, 0xF0)))
                                {
                                    Store (0x02, Local1)
                                    Store (0x01, Local2)
                                    Store (0x00, Local3)
                                    Store (0x04, Local4)
                                    Store (0x04, Local5)
                                }
                                Else
                                {
                                    If (LNot (LGreater (Local0, 0x017F)))
                                    {
                                        Store (0x02, Local1)
                                        Store (0x03, Local2)
                                        Store (0x00, Local3)
                                        Store (0x08, Local4)
                                        Store (0x05, Local5)
                                    }
                                }
                            }
                        }

                        If (LNot (LEqual (Local0, 0xFFFFFFFF)))
                        {
                            Store (Local1, \_SB.PCI0.FNC1.PAST)
                            Store (Local2, \_SB.PCI0.FNC1.PCRC)
                            Store (Local3, \_SB.PCI0.FNC1.PCAC)
                            Store (Local4, \_SB.PCI0.FNC1.PDRC)
                            Store (Local5, \_SB.PCI0.FNC1.PDAC)
                            Store (0x05, \_SB.PCI0.FNC1.FTHP)
                        }

                        Store (PDMA, Local0)
                        Store (PFLG, Local1)
                        And (Local1, 0x01, Local1)
                        ShiftLeft (Local1, 0x03, Local1)
                        If (Local1)
                        {
                            Store (0x04, Local2)
                            If (LNot (LGreater (Local0, 0x1E)))
                            {
                                Store (0x00, Local2)
                            }
                            Else
                            {
                                If (LNot (LGreater (Local0, 0x2D)))
                                {
                                    Store (0x01, Local2)
                                }
                                Else
                                {
                                    If (LNot (LGreater (Local0, 0x3C)))
                                    {
                                        Store (0x02, Local2)
                                    }
                                    Else
                                    {
                                        If (LNot (LGreater (Local0, 0x5A)))
                                        {
                                            Store (0x03, Local2)
                                        }
                                    }
                                }
                            }
                        }
                        Else
                        {
                            Store (0x07, Local2)
                            If (LNot (LGreater (Local0, 0x4B)))
                            {
                                Store (0x05, Local2)
                            }
                            Else
                            {
                                If (LNot (LGreater (Local0, 0x5A)))
                                {
                                    Store (0x06, Local2)
                                }
                            }
                        }

                        If (LNot (LEqual (Local0, 0xFFFFFFFF)))
                        {
                            Or (Local1, Local2, Local1)
                            Store (Local1, \_SB.PCI0.FNC1.PUDS)
                            Store (0x01, \_SB.PCI0.FNC1.FTHP)
                        }
                    }

                    Method (_GTM, 0, NotSerialized)
                    {
                        While (LEqual (\_SB.MEM.ID0R, 0x00)) {}
                        Store (0x01, \_SB.MEM.HTM0)
                        Store (\_SB.PCI0.FNC1.PCRC, Local0)
                        Store (\_SB.PCI0.FNC1.PCAC, Local1)
                        ShiftLeft (Local1, 0x04, Local1)
                        Or (Local0, Local1, Local0)
                        Store (0x0258, Local2)
                        If (LEqual (Local0, 0x31))
                        {
                            Store (0x78, Local2)
                        }
                        Else
                        {
                            If (LEqual (Local0, 0x33))
                            {
                                Store (0xB4, Local2)
                            }
                            Else
                            {
                                If (LEqual (Local0, 0x01))
                                {
                                    Store (0xF0, Local2)
                                }
                                Else
                                {
                                    If (LEqual (Local0, 0x03))
                                    {
                                        Store (0x017F, Local2)
                                    }
                                }
                            }
                        }

                        Store (\_SB.PCI0.FNC1.PUDS, Local0)
                        And (Local0, 0x08, Local1)
                        And (Local0, 0x07, Local0)
                        Store (0x02, Local4)
                        If (Local1)
                        {
                            Store (0x03, Local4)
                            Store (0x78, Local3)
                            If (LEqual (Local0, 0x00))
                            {
                                Store (0x1E, Local3)
                            }
                            Else
                            {
                                If (LEqual (Local0, 0x01))
                                {
                                    Store (0x2D, Local3)
                                }
                                Else
                                {
                                    If (LEqual (Local0, 0x02))
                                    {
                                        Store (0x3C, Local3)
                                    }
                                    Else
                                    {
                                        If (LEqual (Local0, 0x03))
                                        {
                                            Store (0x5A, Local3)
                                        }
                                    }
                                }
                            }
                        }
                        Else
                        {
                            Store (0x69, Local3)
                            If (LEqual (Local0, 0x05))
                            {
                                Store (0x4B, Local3)
                            }
                            Else
                            {
                                If (LEqual (Local0, 0x06))
                                {
                                    Store (0x5A, Local3)
                                }
                            }
                        }

                        Name (BUFF, Buffer (0x14) {})
                        CreateDWordField (BUFF, 0x00, PIO1)
                        CreateDWordField (BUFF, 0x04, DMA1)
                        CreateDWordField (BUFF, 0x08, PIO2)
                        CreateDWordField (BUFF, 0x0C, DMA2)
                        CreateDWordField (BUFF, 0x10, FLGS)
                        Store (Local2, PIO1)
                        Store (Local3, DMA1)
                        Store (0xFFFFFFFF, PIO2)
                        Store (0xFFFFFFFF, DMA2)
                        Store (Local4, FLGS)
                        Return (BUFF)
                    }

                    Device (HD_0)
                    {
                        Name (_ADR, 0x00)
                        Method (_GTF, 0, NotSerialized)
                        {
                            While (LEqual (\_SB.MEM.ID0R, 0x00)) {}
                            Store (0x01, \_SB.MEM.HTM0)
                            Name (BUFF, Buffer (0x0E)
                            {
                                0x03, 0x0C, 0x00, 0x00, 0x00, 0x00, 0xEF, 0=
x03,=20
                                0x23, 0x00, 0x00, 0x00, 0x00, 0xEF
                            })
                            CreateByteField (BUFF, 0x01, PIOM)
                            CreateByteField (BUFF, 0x08, DMAM)
                            Store (\_SB.PCI0.FNC1.PCRC, Local0)
                            Store (\_SB.PCI0.FNC1.PCAC, Local1)
                            ShiftLeft (Local1, 0x04, Local1)
                            Or (Local0, Local1, Local0)
                            Store (0x08, Local1)
                            If (LEqual (Local0, 0x31))
                            {
                                Store (0x0C, Local1)
                            }
                            Else
                            {
                                If (LEqual (Local0, 0x33))
                                {
                                    Store (0x0B, Local1)
                                }
                                Else
                                {
                                    If (LEqual (Local0, 0x01))
                                    {
                                        Store (0x0A, Local1)
                                    }
                                    Else
                                    {
                                        If (LEqual (Local0, 0x03))
                                        {
                                            Store (0x09, Local1)
                                        }
                                    }
                                }
                            }

                            Store (\_SB.PCI0.FNC1.PUDS, Local0)
                            And (Local0, 0x08, Local2)
                            And (Local0, 0x07, Local0)
                            If (Local2)
                            {
                                Store (0x40, Local2)
                                If (LEqual (Local0, 0x00))
                                {
                                    Store (0x44, Local2)
                                }
                                Else
                                {
                                    If (LEqual (Local0, 0x01))
                                    {
                                        Store (0x43, Local2)
                                    }
                                    Else
                                    {
                                        If (LEqual (Local0, 0x02))
                                        {
                                            Store (0x42, Local2)
                                        }
                                        Else
                                        {
                                            If (LEqual (Local0, 0x03))
                                            {
                                                Store (0x41, Local2)
                                            }
                                        }
                                    }
                                }
                            }
                            Else
                            {
                                Store (0x20, Local2)
                                If (LEqual (Local0, 0x05))
                                {
                                    Store (0x22, Local2)
                                }
                                Else
                                {
                                    If (LEqual (Local0, 0x06))
                                    {
                                        Store (0x21, Local2)
                                    }
                                }
                            }

                            Store (Local1, PIOM)
                            Store (Local2, DMAM)
                            Return (BUFF)
                        }
                    }
                }

                Device (IDE1)
                {
                    Name (_ADR, 0x01)
                    Method (_PS0, 0, NotSerialized)
                    {
                        While (LEqual (\_SB.MEM.ID1R, 0x00)) {}
                        SMBR (0xFE00, 0x14, 0x00, 0x00, 0xB2)
                        And (\_SB.MEM.OECX, 0x02, Local0)
                        If (Local0)
                        {
                            Store (0x00, \_SB.MEM.SPSC)
                            Store (0x01, \_SB.MEM.IESI)
                            Store (0x02, \_SB.MEM.IEDI)
                            SMBR (0xFE00, 0x23, 0x20, 0x00, 0xB2)
                            If (\_SB.MEM.OEDX)
                            {
                                Store (0x01, \_SB.MEM.IESI)
                                Store (0x02, \_SB.MEM.IEDI)
                                SMBR (0xFF00, 0x23, 0x20, 0x00, 0xB2)
                                Store (0x01, \_SB.MEM.OECX)
                                While (\_SB.MEM.OECX)
                                {
                                    Store (0x01, \_SB.MEM.IESI)
                                    Store (0x02, \_SB.MEM.IEDI)
                                    SMBR (0xFE00, 0x23, 0x20, 0x00, 0xB2)
                                }
                            }
                        }
                    }

                    Method (_PS3, 0, NotSerialized)
                    {
                        While (LEqual (\_SB.MEM.ID1R, 0x00)) {}
                        SMBR (0xFE00, 0x14, 0x00, 0x00, 0xB2)
                        And (\_SB.MEM.OECX, 0x02, Local0)
                        If (Local0)
                        {
                            Store (0x01, \_SB.MEM.SPSC)
                            Store (0x01, \_SB.MEM.IESI)
                            Store (0x02, \_SB.MEM.IEDI)
                            SMBR (0xFE00, 0x23, 0x20, 0x00, 0xB2)
                            If (LNot (LEqual (\_SB.MEM.OEDX, 0x03)))
                            {
                                Store (0x01, \_SB.MEM.IESI)
                                Store (0x02, \_SB.MEM.IEDI)
                                SMBR (0xFF00, 0x23, 0x20, 0x03, 0xB2)
                                Store (0x01, \_SB.MEM.OECX)
                                While (\_SB.MEM.OECX)
                                {
                                    Store (0x01, \_SB.MEM.IESI)
                                    Store (0x02, \_SB.MEM.IEDI)
                                    SMBR (0xFE00, 0x23, 0x20, 0x00, 0xB2)
                                }
                            }
                        }
                    }

                    Method (_PSC, 0, NotSerialized)
                    {
                        While (LEqual (\_SB.MEM.ID1R, 0x00)) {}
                        SMBR (0xFE00, 0x14, 0x00, 0x00, 0xB2)
                        And (\_SB.MEM.OECX, 0x02, Local0)
                        If (Local0)
                        {
                            If (\_SB.MEM.SPSC)
                            {
                                Return (0x03)
                            }
                            Else
                            {
                                Return (0x00)
                            }
                        }
                        Else
                        {
                            Return (0x00)
                        }
                    }

                    Method (_STM, 3, NotSerialized)
                    {
                        While (LEqual (\_SB.MEM.ID1R, 0x00)) {}
                        Store (0x01, \_SB.MEM.HTM1)
                        CreateDWordField (Arg0, 0x00, PPIO)
                        CreateDWordField (Arg0, 0x04, PDMA)
                        CreateDWordField (Arg0, 0x10, PFLG)
                        Store (PPIO, Local0)
                        Store (0x03, Local1)
                        Store (0x0A, Local2)
                        Store (0x00, Local3)
                        Store (0x08, Local4)
                        Store (0x08, Local5)
                        If (LNot (LGreater (Local0, 0x78)))
                        {
                            Store (0x02, Local1)
                            Store (0x01, Local2)
                            Store (0x03, Local3)
                            Store (0x01, Local4)
                            Store (0x03, Local5)
                        }
                        Else
                        {
                            If (LNot (LGreater (Local0, 0xB4)))
                            {
                                Store (0x02, Local1)
                                Store (0x03, Local2)
                                Store (0x03, Local3)
                                Store (0x03, Local4)
                                Store (0x03, Local5)
                            }
                            Else
                            {
                                If (LNot (LGreater (Local0, 0xF0)))
                                {
                                    Store (0x02, Local1)
                                    Store (0x01, Local2)
                                    Store (0x00, Local3)
                                    Store (0x04, Local4)
                                    Store (0x04, Local5)
                                }
                                Else
                                {
                                    If (LNot (LGreater (Local0, 0x017F)))
                                    {
                                        Store (0x02, Local1)
                                        Store (0x03, Local2)
                                        Store (0x00, Local3)
                                        Store (0x08, Local4)
                                        Store (0x05, Local5)
                                    }
                                }
                            }
                        }

                        If (LNot (LEqual (Local0, 0xFFFFFFFF)))
                        {
                            Store (Local1, \_SB.PCI0.FNC1.SAST)
                            Store (Local2, \_SB.PCI0.FNC1.SCRC)
                            Store (Local3, \_SB.PCI0.FNC1.SCAC)
                            Store (Local4, \_SB.PCI0.FNC1.SDRC)
                            Store (Local5, \_SB.PCI0.FNC1.SDAC)
                            Store (0x05, \_SB.PCI0.FNC1.FTHS)
                        }

                        Store (PDMA, Local0)
                        Store (PFLG, Local1)
                        And (Local1, 0x01, Local1)
                        ShiftLeft (Local1, 0x03, Local1)
                        If (Local1)
                        {
                            Store (0x04, Local2)
                            If (LNot (LGreater (Local0, 0x1E)))
                            {
                                Store (0x00, Local2)
                            }
                            Else
                            {
                                If (LNot (LGreater (Local0, 0x2D)))
                                {
                                    Store (0x01, Local2)
                                }
                                Else
                                {
                                    If (LNot (LGreater (Local0, 0x3C)))
                                    {
                                        Store (0x02, Local2)
                                    }
                                    Else
                                    {
                                        If (LNot (LGreater (Local0, 0x5A)))
                                        {
                                            Store (0x03, Local2)
                                        }
                                    }
                                }
                            }
                        }
                        Else
                        {
                            Store (0x07, Local2)
                            If (LNot (LGreater (Local0, 0x4B)))
                            {
                                Store (0x05, Local2)
                            }
                            Else
                            {
                                If (LNot (LGreater (Local0, 0x5A)))
                                {
                                    Store (0x06, Local2)
                                }
                            }
                        }

                        If (LNot (LEqual (Local0, 0xFFFFFFFF)))
                        {
                            Or (Local1, Local2, Local1)
                            Store (Local1, \_SB.PCI0.FNC1.SUDS)
                            Store (0x01, \_SB.PCI0.FNC1.FTHS)
                        }
                    }

                    Method (_GTM, 0, NotSerialized)
                    {
                        While (LEqual (\_SB.MEM.ID1R, 0x00)) {}
                        Store (0x01, \_SB.MEM.HTM1)
                        Store (\_SB.PCI0.FNC1.SCRC, Local0)
                        Store (\_SB.PCI0.FNC1.SCAC, Local1)
                        ShiftLeft (Local1, 0x04, Local1)
                        Or (Local0, Local1, Local0)
                        Store (0x0258, Local2)
                        If (LEqual (Local0, 0x31))
                        {
                            Store (0x78, Local2)
                        }
                        Else
                        {
                            If (LEqual (Local0, 0x33))
                            {
                                Store (0xB4, Local2)
                            }
                            Else
                            {
                                If (LEqual (Local0, 0x01))
                                {
                                    Store (0xF0, Local2)
                                }
                                Else
                                {
                                    If (LEqual (Local0, 0x03))
                                    {
                                        Store (0x017F, Local2)
                                    }
                                }
                            }
                        }

                        Store (\_SB.PCI0.FNC1.SUDS, Local0)
                        And (Local0, 0x08, Local1)
                        And (Local0, 0x07, Local0)
                        Store (0x02, Local4)
                        If (Local1)
                        {
                            Store (0x03, Local4)
                            Store (0x78, Local3)
                            If (LEqual (Local0, 0x00))
                            {
                                Store (0x1E, Local3)
                            }
                            Else
                            {
                                If (LEqual (Local0, 0x01))
                                {
                                    Store (0x2D, Local3)
                                }
                                Else
                                {
                                    If (LEqual (Local0, 0x02))
                                    {
                                        Store (0x3C, Local3)
                                    }
                                    Else
                                    {
                                        If (LEqual (Local0, 0x03))
                                        {
                                            Store (0x5A, Local3)
                                        }
                                    }
                                }
                            }
                        }
                        Else
                        {
                            Store (0x69, Local3)
                            If (LEqual (Local0, 0x05))
                            {
                                Store (0x4B, Local3)
                            }
                            Else
                            {
                                If (LEqual (Local0, 0x06))
                                {
                                    Store (0x5A, Local3)
                                }
                            }
                        }

                        Name (BUFF, Buffer (0x14) {})
                        CreateDWordField (BUFF, 0x00, PIO1)
                        CreateDWordField (BUFF, 0x04, DMA1)
                        CreateDWordField (BUFF, 0x08, PIO2)
                        CreateDWordField (BUFF, 0x0C, DMA2)
                        CreateDWordField (BUFF, 0x10, FLGS)
                        Store (Local2, PIO1)
                        Store (Local3, DMA1)
                        Store (0xFFFFFFFF, PIO2)
                        Store (0xFFFFFFFF, DMA2)
                        Store (Local4, FLGS)
                        Return (BUFF)
                    }

                    Device (HD_1)
                    {
                        Name (_ADR, 0x00)
                        Method (_STA, 0, NotSerialized)
                        {
                            While (LEqual (\_SB.MEM.ID1R, 0x00)) {}
                            SMBR (0xFE00, 0x14, 0x00, 0x00, 0xB2)
                            And (\_SB.MEM.OECX, 0x02, Local0)
                            If (Local0)
                            {
                                Return (0x0F)
                            }
                            Else
                            {
                                Return (0x00)
                            }
                        }

                        Method (_EJ0, 1, NotSerialized)
                        {
                            SMBR (0xFE00, 0x14, 0x00, 0x00, 0xB2)
                            And (\_SB.MEM.OECX, 0x02, Local0)
                            If (Local0)
                            {
                                Store (0x01, \_SB.MEM.IESI)
                                Store (0x02, \_SB.MEM.IEDI)
                                SMBR (0xFE00, 0x23, 0x20, 0x00, 0xB2)
                                If (LNot (LEqual (\_SB.MEM.OEDX, 0x03)))
                                {
                                    Store (0x01, \_SB.MEM.IESI)
                                    Store (0x02, \_SB.MEM.IEDI)
                                    SMBR (0xFF00, 0x23, 0x20, 0x03, 0xB2)
                                    Store (0x01, \_SB.MEM.OECX)
                                    While (\_SB.MEM.OECX)
                                    {
                                        Store (0x01, \_SB.MEM.IESI)
                                        Store (0x02, \_SB.MEM.IEDI)
                                        SMBR (0xFE00, 0x23, 0x20, 0x00, 0xB=
2)
                                    }
                                }
                            }
                        }

                        Method (_GTF, 0, NotSerialized)
                        {
                            While (LEqual (\_SB.MEM.ID1R, 0x00)) {}
                            Store (0x01, \_SB.MEM.HTM1)
                            Name (BUFF, Buffer (0x0E)
                            {
                                0x03, 0x0C, 0x00, 0x00, 0x00, 0x00, 0xEF, 0=
x03,=20
                                0x23, 0x00, 0x00, 0x00, 0x00, 0xEF
                            })
                            CreateByteField (BUFF, 0x01, PIOM)
                            CreateByteField (BUFF, 0x08, DMAM)
                            Store (\_SB.PCI0.FNC1.SCRC, Local0)
                            Store (\_SB.PCI0.FNC1.SCAC, Local1)
                            ShiftLeft (Local1, 0x04, Local1)
                            Or (Local0, Local1, Local0)
                            Store (0x08, Local1)
                            If (LEqual (Local0, 0x31))
                            {
                                Store (0x0C, Local1)
                            }
                            Else
                            {
                                If (LEqual (Local0, 0x33))
                                {
                                    Store (0x0B, Local1)
                                }
                                Else
                                {
                                    If (LEqual (Local0, 0x01))
                                    {
                                        Store (0x0A, Local1)
                                    }
                                    Else
                                    {
                                        If (LEqual (Local0, 0x03))
                                        {
                                            Store (0x09, Local1)
                                        }
                                    }
                                }
                            }

                            Store (\_SB.PCI0.FNC1.SUDS, Local0)
                            And (Local0, 0x08, Local2)
                            And (Local0, 0x07, Local0)
                            If (Local2)
                            {
                                Store (0x40, Local2)
                                If (LEqual (Local0, 0x00))
                                {
                                    Store (0x44, Local2)
                                }
                                Else
                                {
                                    If (LEqual (Local0, 0x01))
                                    {
                                        Store (0x43, Local2)
                                    }
                                    Else
                                    {
                                        If (LEqual (Local0, 0x02))
                                        {
                                            Store (0x42, Local2)
                                        }
                                        Else
                                        {
                                            If (LEqual (Local0, 0x03))
                                            {
                                                Store (0x41, Local2)
                                            }
                                        }
                                    }
                                }
                            }
                            Else
                            {
                                Store (0x20, Local2)
                                If (LEqual (Local0, 0x05))
                                {
                                    Store (0x22, Local2)
                                }
                                Else
                                {
                                    If (LEqual (Local0, 0x06))
                                    {
                                        Store (0x21, Local2)
                                    }
                                }
                            }

                            Store (Local1, PIOM)
                            Store (Local2, DMAM)
                            Return (BUFF)
                        }
                    }
                }
            }

            Device (USB1)
            {
                Name (_ADR, 0x00020000)
                OperationRegion (USP1, PCI_Config, 0x00, 0xFF)
                Field (USP1, ByteAcc, NoLock, Preserve)
                {
                    UVI1,   16,=20
                    UDI1,   16,=20
                    Offset (0x09),=20
                    UPI1,   8,=20
                    USC1,   8,=20
                    UBC1,   8
                }

                Name (_PRW, Package (0x02)
                {
                    0x09,=20
                    0x03
                })
                Method (_PSW, 1, NotSerialized)
                {
                    If (Arg0)
                    {
                        Store (0x01, \_SB.MEM.WED3)
                    }
                    Else
                    {
                        Store (0x00, \_SB.MEM.WED3)
                    }
                }

                Device (RHB0)
                {
                    Name (_ADR, 0x00)
                    Device (PT01)
                    {
                        Name (_ADR, 0x01)
                        Name (_EJD, "\\_SB_.PCI0.DOCK")
                    }

                    Device (PT02)
                    {
                        Name (_ADR, 0x02)
                        Name (_EJD, "\\_SB_.PCI0.DOCK")
                    }
                }
            }

            Device (ASND)
            {
                Name (_ADR, 0x00060000)
                Method (_PS0, 0, NotSerialized)
                {
                    While (LEqual (\_SB.MEM.ACLR, 0x00)) {}
                    Store (0x00, \_SB.MEM.PSND)
                }

                Method (_PS3, 0, NotSerialized)
                {
                    Store (0x01, \_SB.MEM.PSND)
                }

                Method (_PSC, 0, NotSerialized)
                {
                    If (\_SB.MEM.PSND)
                    {
                        Return (0x03)
                    }
                    Else
                    {
                        Return (0x00)
                    }
                }

                Name (_PRW, Package (0x02)
                {
                    0x09,=20
                    0x03
                })
                Method (_PSW, 1, NotSerialized)
                {
                    If (Arg0)
                    {
                        Store (0x01, \_SB.MEM.WED1)
                    }
                    Else
                    {
                        Store (0x00, \_SB.MEM.WED1)
                    }
                }
            }

            Device (IEEE)
            {
                Name (_ADR, 0x000C0000)
                OperationRegion (IEEC, PCI_Config, 0x00, 0xFF)
                Field (IEEC, ByteAcc, NoLock, Preserve)
                {
                    IVI0,   16,=20
                    IDI0,   16,=20
                    Offset (0x09),=20
                    IPI0,   8,=20
                    ISC0,   8,=20
                    IBC0,   8
                }

                Name (_EJD, "\\_SB_.PCI0.DOCK")
            }

            Device (VIY0)
            {
                Name (_ADR, 0x00110000)
                Name (_SUN, 0x00)
                Name (_PRW, Package (0x02)
                {
                    0x09,=20
                    0x03
                })
                Method (_PSW, 1, NotSerialized)
                {
                    If (Arg0)
                    {
                        Store (0x01, \_SB.MEM.VWE0)
                    }
                    Else
                    {
                        Store (0x00, \_SB.MEM.VWE0)
                    }
                }
            }

            Device (VIY1)
            {
                Name (_ADR, 0x00110001)
                Name (_SUN, 0x01)
                Name (_PRW, Package (0x02)
                {
                    0x09,=20
                    0x03
                })
                Method (_PSW, 1, NotSerialized)
                {
                    If (Arg0)
                    {
                        Store (0x01, \_SB.MEM.VWE1)
                    }
                    Else
                    {
                        Store (0x00, \_SB.MEM.VWE1)
                    }
                }
            }

            Device (LAN)
            {
                Name (_ADR, 0x000A0000)
                OperationRegion (PLAN, PCI_Config, 0x00, 0xFF)
                Field (PLAN, ByteAcc, NoLock, Preserve)
                {
                    PLVI,   16,=20
                    Offset (0xE1),=20
                    PMES,   8
                }

                Name (_PRW, Package (0x02)
                {
                    0x09,=20
                    0x04
                })
                Method (_PSW, 1, NotSerialized)
                {
                    If (Arg0)
                    {
                        Store (0x01, \_SB.MEM.WED4)
                    }
                    Else
                    {
                        Store (0x00, \_SB.MEM.WED4)
                    }
                }
            }

            Device (MPC0)
            {
                Name (_ADR, 0x00100000)
                OperationRegion (MPF0, PCI_Config, 0x00, 0xFF)
                Field (MPF0, ByteAcc, NoLock, Preserve)
                {
                    Offset (0x0A),=20
                    MCC0,   16
                }

                Method (_PRW, 0, NotSerialized)
                {
                    Name (BUFF, Package (0x02)
                    {
                        0x09,=20
                        0x04
                    })
                    If (LEqual (\_SB.PCI0.MPC0.MCC0, 0x0200)) {}
                    Else
                    {
                        Store (0x03, Index (BUFF, 0x01))
                    }

                    Return (BUFF)
                }

                Method (_PSW, 1, NotSerialized)
                {
                    If (Arg0)
                    {
                        Store (0x01, \_SB.MEM.WEF0)
                    }
                    Else
                    {
                        Store (0x00, \_SB.MEM.WEF0)
                    }
                }
            }

            Device (MPC1)
            {
                Name (_ADR, 0x00100001)
                OperationRegion (MPF1, PCI_Config, 0x00, 0xFF)
                Field (MPF1, ByteAcc, NoLock, Preserve)
                {
                    Offset (0x0A),=20
                    MCC1,   16
                }

                Method (_PRW, 0, NotSerialized)
                {
                    Name (BUFF, Package (0x02)
                    {
                        0x09,=20
                        0x04
                    })
                    If (LEqual (\_SB.PCI0.MPC1.MCC1, 0x0200)) {}
                    Else
                    {
                        Store (0x03, Index (BUFF, 0x01))
                    }

                    Return (BUFF)
                }

                Method (_PSW, 1, NotSerialized)
                {
                    If (Arg0)
                    {
                        Store (0x01, \_SB.MEM.WEF1)
                    }
                    Else
                    {
                        Store (0x00, \_SB.MEM.WEF1)
                    }
                }
            }

            Device (SDC)
            {
                Name (_ADR, 0x00120000)
            }

            Device (DOCK)
            {
                Name (_HID, EisaId ("PNP0A05"))
                Method (_STA, 0, NotSerialized)
                {
                    SMBR (0x0136FA00, 0x05F3, 0x00, 0x00, 0xB2)
                    And (\_SB.MEM.OEAX, 0xFF00, Local0)
                    If (LOr (LAnd (LEqual (Local0, 0x00), LEqual (\_SB.MEM.=
OECX, 0x00)), LNot (LEqual (Local0, 0x00))))
                    {
                        Store (0x00, \_SB.MEM.RDID)
                        Store (0x00, \_SB.MEM.RDSN)
                        Store (0x05, \_SB.PCI0.FNC0.SYSR.TRP4)
                        Store (\_SB.MEM.RDID, \_SB.MEM.DLID)
                        Store (\_SB.MEM.RDSN, \_SB.MEM.DSRN)
                        If (\_SB.MEM.PAR1)
                        {
                            Return (0x00)
                        }
                        Else
                        {
                            If (LOr (LEqual (0x1B51F351, \_SB.MEM.RDID), LE=
qual (0x1C51F351, \_SB.MEM.RDID)))
                            {
                                Return (0x0F)
                            }
                            Else
                            {
                                If (LEqual (0x1D51F351, \_SB.MEM.RDID))
                                {
                                    Return (0x0F)
                                }
                                Else
                                {
                                    Return (0x00)
                                }
                            }
                        }
                    }
                    Else
                    {
                        Return (0x00)
                    }
                }

                Method (_BDN, 0, NotSerialized)
                {
                    Store (0x00, \_SB.MEM.RDID)
                    Store (0x05, \_SB.PCI0.FNC0.SYSR.TRP4)
                    Return (\_SB.MEM.RDID)
                }

                Method (_UID, 0, NotSerialized)
                {
                    Store (0x00, \_SB.MEM.RDSN)
                    Store (0x05, \_SB.PCI0.FNC0.SYSR.TRP4)
                    Return (\_SB.MEM.RDSN)
                }

                Method (_DCK, 1, NotSerialized)
                {
                    If (Arg0)
                    {
                        Store (0x05, \_SB.PCI0.FNC0.SYSR.TRP4)
                        If (\_SB.MEM.PAR1)
                        {
                            Store (0x41, \_SB.PCI0.FNC0.SYSR.TRP4)
                            Reset (\_SB.PCI0.DKSQ)
                            Wait (\_SB.PCI0.DKSQ, 0x0BB8)
                            Notify (\_SB.PCI0.PCI1.VGA, 0x80)
                            DIS (0x23)
                            Return (One)
                        }

                        Return (Zero)
                    }
                    Else
                    {
                        Return (One)
                    }
                }

                Method (_EJ0, 1, NotSerialized)
                {
                    If (LOr (\_SB.MEM.BES1, \_SB.MEM.BES2))
                    {
                        Store (0x40, \_SB.PCI0.FNC0.SYSR.TRP4)
                        Reset (\_SB.PCI0.DKSQ)
                        Wait (\_SB.PCI0.DKSQ, 0x1388)
                        Notify (\_SB.PCI0.PCI1.VGA, 0x80)
                    }
                }

                Device (ATAE)
                {
                    Name (_HID, EisaId ("PNP0600"))
                    Name (_UID, 0x04)
                    Method (_STA, 0, NotSerialized)
                    {
                        Return (STA (0x24))
                    }

                    Method (_CRS, 0, NotSerialized)
                    {
                        Return (CRS (0x24))
                    }

                    Method (_PRS, 0, NotSerialized)
                    {
                        Return (PRS (0x24))
                    }

                    Method (_SRS, 1, NotSerialized)
                    {
                        SRS (0x24, Arg0)
                    }

                    Method (_DIS, 0, NotSerialized)
                    {
                        DIS (0x24)
                    }
                }

                Device (PCE0)
                {
                    Name (_HID, EisaId ("PNP0E00"))
                    Name (_UID, 0x02)
                    Method (_STA, 0, NotSerialized)
                    {
                        Return (STA (0x25))
                    }

                    Method (_CRS, 0, NotSerialized)
                    {
                        Return (CRS (0x25))
                    }

                    Method (_PRS, 0, NotSerialized)
                    {
                        Return (PRS (0x25))
                    }

                    Method (_SRS, 1, NotSerialized)
                    {
                        SRS (0x25, Arg0)
                    }

                    Method (_DIS, 0, NotSerialized)
                    {
                        DIS (0x25)
                    }

                    Method (_PS0, 0, NotSerialized)
                    {
                        PS0 (0x25)
                    }

                    Method (_PS3, 0, NotSerialized)
                    {
                        PS3 (0x25)
                    }

                    Method (_PSC, 0, NotSerialized)
                    {
                        Return (PSC (0x25))
                    }

                    Name (_PRW, Package (0x02)
                    {
                        0x09,=20
                        0x03
                    })
                    Method (_PSW, 1, NotSerialized)
                    {
                        Store (Arg0, \_SB.MEM.WED2)
                    }

                    Device (PCS2)
                    {
                        Name (_ADR, 0x00)
                        Name (_SUN, 0x02)
                    }
                }

                PowerResource (PDOC, 0x01, 0x0000)
                {
                    Method (_STA, 0, NotSerialized)
                    {
                        Return (\_SB.MEM.DSPW)
                    }

                    Method (_ON, 0, NotSerialized)
                    {
                        Store (0x01, \_SB.MEM.DSPW)
                    }

                    Method (_OFF, 0, NotSerialized)
                    {
                        Store (0x00, \_SB.MEM.DSPW)
                    }
                }

                Name (_PR0, Package (0x01)
                {
                    \_SB.PCI0.DOCK.PDOC
                })
                Name (_PR1, Package (0x01)
                {
                    \_SB.PCI0.DOCK.PDOC
                })
            }

            Event (DKSQ)
            Device (NOV0)
            {
                Name (_ADR, 0x00140000)
                OperationRegion (NVC0, PCI_Config, 0x00, 0xFF)
                Field (NVC0, ByteAcc, NoLock, Preserve)
                {
                    TVI0,   16,=20
                    TDI0,   16,=20
                    Offset (0x09),=20
                    TPI0,   8,=20
                    TSC0,   8,=20
                    TBC0,   8
                }

                Name (_SUN, 0x02)
                Name (_EJD, "\\_SB_.PCI0.DOCK")
                Name (_PRW, Package (0x02)
                {
                    0x09,=20
                    0x03
                })
                Method (_PSW, 1, NotSerialized)
                {
                    If (Arg0)
                    {
                        Store (0x01, \_SB.MEM.VWE2)
                    }
                    Else
                    {
                        Store (0x00, \_SB.MEM.VWE2)
                    }
                }
            }

            Device (PCI1)
            {
                Name (_ADR, 0x00010000)
                Name (_PRT, Package (0x01)
                {
                    Package (0x04)
                    {
                        0xFFFF,=20
                        0x00,=20
                        \_SB.PCI0.FNC0.LNKC,=20
                        0x00
                    }
                })
                Device (VGA)
                {
                    Name (_ADR, 0x00)
                    Method (_PS0, 0, Serialized)
                    {
                        While (LEqual (\_SB.MEM.VGAR, 0x00)) {}
                        Store (0x01, \_SB.MEM.IESI)
                        Store (0x00, \_SB.MEM.IEDI)
                        SMBR (0xFE00, 0x23, 0x0100, 0x00, 0xB2)
                        If (LEqual (\_SB.MEM.OEAX, 0x00))
                        {
                            Store (0x01, \_SB.MEM.IESI)
                            Store (0x00, \_SB.MEM.IEDI)
                            SMBR (0xFF00, 0x23, 0x0100, 0x00, 0xB2)
                            WPSX (0x0100, 0x01, 0x00, 0x00)
                            Store (0x00, \_SB.MEM.VGAF)
                        }
                    }

                    Method (_PS3, 0, Serialized)
                    {
                        While (LEqual (\_SB.MEM.VGAR, 0x00)) {}
                        Store (0x01, \_SB.MEM.IESI)
                        Store (0x00, \_SB.MEM.IEDI)
                        SMBR (0xFE00, 0x23, 0x0100, 0x00, 0xB2)
                        If (LEqual (\_SB.MEM.OEAX, 0x00))
                        {
                            Store (0x01, \_SB.MEM.IESI)
                            Store (0x00, \_SB.MEM.IEDI)
                            SMBR (0xFF00, 0x23, 0x0100, 0x03, 0xB2)
                            WPSX (0x0100, 0x01, 0x00, 0x03)
                            Store (0x01, \_SB.MEM.VGAF)
                        }
                    }

                    Method (_PSC, 0, NotSerialized)
                    {
                        While (LEqual (\_SB.MEM.VGAR, 0x00)) {}
                        Store (0x01, \_SB.MEM.IESI)
                        Store (0x00, \_SB.MEM.IEDI)
                        SMBR (0xFE00, 0x23, 0x0100, 0x00, 0xB2)
                        Return (\_SB.MEM.OEDX)
                    }

                    Method (_DOS, 1, NotSerialized)
                    {
                        If (LEqual (Arg0, 0x00))
                        {
                            Store (0x01, \_SB.MEM.DCST)
                            Store (0x00, \_SB.MEM.DOS2)
                        }
                        Else
                        {
                            If (LEqual (Arg0, 0x01))
                            {
                                Store (0x00, \_SB.MEM.DCST)
                                Store (0x01, \_SB.MEM.DOS2)
                            }
                            Else
                            {
                                If (LEqual (Arg0, 0x02))
                                {
                                    Store (0x01, \_SB.MEM.DCST)
                                    Store (0x01, \_SB.MEM.DOS2)
                                }
                            }
                        }
                    }

                    Method (_DOD, 0, NotSerialized)
                    {
                        Name (BUFF, Package (0x02)
                        {
                            0x0110,=20
                            0x0100
                        })
                        Return (BUFF)
                    }

                    Method (_ROM, 2, NotSerialized)
                    {
                        Add (Arg0, 0x000C0000, Local0)
                        ShiftLeft (Arg1, 0x03, Local1)
                        Name (BUFF, Buffer (Arg1) {})
                        Scope (\)
                        {
                            OperationRegion (VROM, SystemMemory, Local0, Lo=
cal1)
                            Field (VROM, ByteAcc, NoLock, Preserve)
                            {
                                ROMI,   65536
                            }
                        }

                        Store (\ROMI, BUFF)
                        Return (BUFF)
                    }

                    Device (LCD)
                    {
                        Name (_ADR, 0x0110)
                        Method (_DCS, 0, NotSerialized)
                        {
                            If (\_SB.MEM.CTLA)
                            {
                                Return (0x0F)
                            }
                            Else
                            {
                                Return (0x0D)
                            }
                        }

                        Method (_DDC, 1, NotSerialized)
                        {
                            If (LEqual (Arg0, 0x01))
                            {
                                Store (0x80, Local0)
                            }
                            Else
                            {
                                If (LEqual (Arg0, 0x02))
                                {
                                    Store (0x0100, Local0)
                                }
                                Else
                                {
                                    Return (Zero)
                                }
                            }

                            Store (0x00, \_SB.MEM.PRES)
                            ShiftLeft (Arg0, 0x08, Local1)
                            Or (Local1, 0x01, Local1)
                            Name (BUFF, Buffer (Local0) {})
                            SMBR (0xFE00, 0x37, Local1, 0x000EF000, 0xB2)
                            And (Local1, 0xFF00, Local1)
                            Store (0x0100, \_SB.MEM.OECX)
                            While (\_SB.MEM.OECX)
                            {
                                SMBR (0xFE00, 0x37, Local1, 0x00, 0xB2)
                            }

                            Store (\_SB.MEM.FSDP, Local0)
                            Or (Local0, 0x22, \_SB.MEM.FSDP)
                            Subtract (\_SB.MEM.FSDP, Local0, Local0)
                            Subtract (\_SB.MEM.EDCK, Local0, \_SB.MEM.EDCK)
                            Store (\_SB.MEM.PRES, BUFF)
                            Return (BUFF)
                        }

                        Method (_DGS, 0, NotSerialized)
                        {
                            If (\_SB.MEM.NXLA)
                            {
                                Return (One)
                            }
                            Else
                            {
                                Return (Zero)
                            }
                        }

                        Method (_DSS, 1, NotSerialized)
                        {
                            Store (Arg0, Local0)
                            And (Local0, 0x01, Local1)
                            If (Local1)
                            {
                                Store (0x01, \_SB.MEM.NXLA)
                            }
                            Else
                            {
                                Store (0x00, \_SB.MEM.NXLA)
                            }

                            And (Local0, 0x80000000, Local1)
                            If (Local1)
                            {
                                Store (0x0100, Local1)
                                If (\_SB.MEM.NXLA)
                                {
                                    Or (0x01, Local1, Local1)
                                }

                                If (\_SB.MEM.NXCA)
                                {
                                    Or (0x02, Local1, Local1)
                                }

                                If (\_SB.MEM.NXTA)
                                {
                                    Or (0x04, Local1, Local1)
                                }

                                If (\_SB.MEM.NXDA)
                                {
                                    Or (0x08, Local1, Local1)
                                }

                                SMBR (0xFF00, 0x1C, Local1, 0x00, 0xB2)
                                And (\_SB.MEM.OEAX, 0xFF00, Local1)
                                If (LEqual (Local1, 0x00))
                                {
                                    Store (0x80, Local1)
                                    While (LEqual (Local1, 0x80))
                                    {
                                        SMBR (0xFE00, 0x1C, 0x00, 0x00, 0xB=
2)
                                        And (\_SB.MEM.OECX, 0x80, Local1)
                                    }

                                    If (\_SB.MEM.CTLA)
                                    {
                                        If (LEqual (\_SB.MEM.LCDS, 0x00))
                                        {
                                            SMBR (0xFF00, 0x02, 0x01, 0x00,=
 0xB2)
                                            Store (0x01, \_SB.MEM.OEDX)
                                            While (\_SB.MEM.OEDX)
                                            {
                                                SMBR (0xFE00, 0x02, 0x00, 0=
x00, 0xB2)
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        Method (_BCL, 0, NotSerialized)
                        {
                            Name (BUFF, Package (0x05)
                            {
                                0x64,=20
                                0x28,=20
                                0x00,=20
                                0x28,=20
                                0x64
                            })
                            If (\_SB.MEM.HPSU)
                            {
                                Store (\_SB.MEM.BCLA, Index (BUFF, 0x00))
                                Store (\_SB.MEM.BCLD, Index (BUFF, 0x01))
                            }

                            Return (BUFF)
                        }

                        Method (_BCM, 1, NotSerialized)
                        {
                            If (LEqual (\_SB.MEM.HPSU, 0x00))
                            {
                                Multiply (Arg0, 0xFFFF, Local0)
                                Divide (Local0, 0x64, , Local0)
                                SMBR (0xFF00, 0x2A, Local0, 0x00, 0xB2)
                            }
                        }

                        Method (_PS0, 0, Serialized)
                        {
                            Store (0x00, \_SB.MEM.LCDS)
                        }

                        Method (_PS3, 0, Serialized)
                        {
                            Store (0x03, \_SB.MEM.LCDS)
                        }

                        Method (_PSC, 0, Serialized)
                        {
                            Return (\_SB.MEM.LCDS)
                        }
                    }

                    Device (CRT)
                    {
                        Name (_ADR, 0x0100)
                        Method (_DCS, 0, NotSerialized)
                        {
                            If (\_SB.MEM.CTCA)
                            {
                                Return (0x0F)
                            }
                            Else
                            {
                                Return (0x0D)
                            }
                        }

                        Method (_DDC, 1, NotSerialized)
                        {
                            If (LEqual (Arg0, 0x01))
                            {
                                Store (0x80, Local0)
                            }
                            Else
                            {
                                If (LEqual (Arg0, 0x02))
                                {
                                    Store (0x0100, Local0)
                                }
                                Else
                                {
                                    Return (Zero)
                                }
                            }

                            Store (0x00, \_SB.MEM.PRES)
                            ShiftLeft (Arg0, 0x08, Local1)
                            Or (Local1, 0x02, Local1)
                            Name (BUFF, Buffer (Local0) {})
                            SMBR (0xFE00, 0x37, Local1, 0x000EF000, 0xB2)
                            And (Local1, 0xFF00, Local1)
                            Store (0x0100, \_SB.MEM.OECX)
                            While (\_SB.MEM.OECX)
                            {
                                SMBR (0xFE00, 0x37, Local1, 0x00, 0xB2)
                            }

                            Store (\_SB.MEM.PRES, BUFF)
                            Return (BUFF)
                        }

                        Method (_DGS, 0, NotSerialized)
                        {
                            If (\_SB.MEM.NXCA)
                            {
                                Return (One)
                            }
                            Else
                            {
                                Return (Zero)
                            }
                        }

                        Method (_DSS, 1, NotSerialized)
                        {
                            Store (Arg0, Local0)
                            And (Local0, 0x01, Local1)
                            If (Local1)
                            {
                                Store (0x01, \_SB.MEM.NXCA)
                            }
                            Else
                            {
                                Store (0x00, \_SB.MEM.NXCA)
                            }

                            And (Local0, 0x80000000, Local1)
                            If (Local1)
                            {
                                Store (0x0100, Local1)
                                If (\_SB.MEM.NXLA)
                                {
                                    Or (0x01, Local1, Local1)
                                }

                                If (\_SB.MEM.NXCA)
                                {
                                    Or (0x02, Local1, Local1)
                                }

                                If (\_SB.MEM.NXTA)
                                {
                                    Or (0x04, Local1, Local1)
                                }

                                SMBR (0xFF00, 0x1C, Local1, 0x00, 0xB2)
                                And (\_SB.MEM.OEAX, 0xFF00, Local1)
                                If (LEqual (Local1, 0x00))
                                {
                                    Store (0x80, Local1)
                                    While (LEqual (Local1, 0x80))
                                    {
                                        SMBR (0xFE00, 0x1C, 0x00, 0x00, 0xB=
2)
                                        And (\_SB.MEM.OECX, 0x80, Local1)
                                    }

                                    If (\_SB.MEM.CTLA)
                                    {
                                        If (LEqual (\_SB.MEM.LCDS, 0x00))
                                        {
                                            SMBR (0xFF00, 0x02, 0x01, 0x00,=
 0xB2)
                                            Store (0x01, \_SB.MEM.OEDX)
                                            While (\_SB.MEM.OEDX)
                                            {
                                                SMBR (0xFE00, 0x02, 0x00, 0=
x00, 0xB2)
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        Method (_PS0, 0, Serialized)
                        {
                            Store (0x00, \_SB.MEM.CRTS)
                        }

                        Method (_PS3, 0, Serialized)
                        {
                            Store (0x03, \_SB.MEM.CRTS)
                        }

                        Method (_PSC, 0, Serialized)
                        {
                            Return (\_SB.MEM.CRTS)
                        }
                    }
                }
            }

            Method (_INI, 0, NotSerialized)
            {
                Store (\_SB.MEM.BES1, \_SB.MEM.BT1F)
                Store (\_SB.MEM.BES2, \_SB.MEM.BT2F)
                Store (0x00, \_SB.MEM.DSPW)
                Store (0x00, \_SB.MEM.VGAF)
                Store (0x00, \_SB.MEM.VWE0)
                Store (0x00, \_SB.MEM.VWE1)
                Store (0x00, \_SB.MEM.PPSC)
                Store (0x00, \_SB.MEM.SPSC)
                Store (0x00, Local0)
                If (CMPS (\_OS, "Microsoft Windows NT"))
                {
                    Store (0x03, Local0)
                    If (CondRefOf (\_OSI, Local1))
                    {
                        If (\_OSI ("Windows 2001"))
                        {
                            Store (0x04, Local0)
                        }
                    }
                }
                Else
                {
                    If (CMPS (\_OS, "Microsoft Windows"))
                    {
                        Store (0x01, Local0)
                    }

                    If (CMPS (\_OS, "Microsoft WindowsME:Millennium Edition=
"))
                    {
                        Store (0x02, Local0)
                    }
                }

                Store (Local0, \_SB.MEM.OSID)
                DIS (0x14)
                DIS (0x23)
                SMBR (0xFF00, 0x1E, 0x01, 0x00, 0xB2)
                Store (0x01, \_SB.MEM.PAR1)
                Store (0x60, \_SB.PCI0.FNC0.SYSR.TRP4)
            }
        }

        Device (BT)
        {
            Name (_HID, "TOS6205")
            Method (_STA, 0, NotSerialized)
            {
                If (\_SB.MEM.BTMD)
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (0x00)
                }
            }

            Name (_PRW, Package (0x02)
            {
                0x09,=20
                0x04
            })
            Method (BTST, 0, NotSerialized)
            {
                Store (0x00, \_SB.MEM.OESI)
                SMBR (0xFE00, 0x4D, 0x01, 0xC600, 0xB2)
                Store (0x01, Local0)
                While (Local0)
                {
                    SMBR (0xFE00, 0x4D, 0x0101, 0xC600, 0xB2)
                    Store (\_SB.MEM.OESI, Local2)
                    And (\_SB.MEM.OEAX, 0xFF00, Local1)
                    If (Local1)
                    {
                        And (\_SB.MEM.OEAX, 0xFF, Local1)
                        If (LNot (LEqual (Local1, 0x20)))
                        {
                            Store (0x00, Local2)
                            Store (0x00, Local0)
                        }
                    }
                    Else
                    {
                        Store (0x00, Local0)
                    }
                }

                And (Local2, 0x02, Local0)
                ShiftLeft (Local0, 0x06, Local0)
                And (Local2, 0x04, Local1)
                ShiftLeft (Local1, 0x04, Local1)
                Or (Local0, Local1, Local0)
                And (Local2, 0x10, Local3)
                ShiftRight (Local3, 0x04, Local3)
                Or (Local0, Local3, Local0)
                Return (Local0)
            }

            Method (AUSB, 0, NotSerialized)
            {
                If (\_SB.MEM.BTMD)
                {
                    Store (0x00, \_SB.MEM.IEDI)
                    Store (0x03, \_SB.MEM.IESI)
                    SMBR (0xFF00, 0x4D, 0x01, 0x7C00, 0xB2)
                    Store (0x01, Local0)
                    While (Local0)
                    {
                        SMBR (0xFF00, 0x4D, 0x0101, 0x7C00, 0xB2)
                        And (\_SB.MEM.OEAX, 0xFF00, Local1)
                        If (Local1)
                        {
                            And (\_SB.MEM.OEAX, 0xFF, Local1)
                            If (LNot (LEqual (Local1, 0x20)))
                            {
                                Store (0x00, Local0)
                            }
                        }
                        Else
                        {
                            Store (0x00, Local0)
                        }
                    }
                }
            }

            Method (DUSB, 0, NotSerialized)
            {
                If (\_SB.MEM.BTMD)
                {
                    Store (0x00, \_SB.MEM.IEDI)
                    Store (0x04, \_SB.MEM.IESI)
                    SMBR (0xFF00, 0x4D, 0x01, 0x7C00, 0xB2)
                    Store (0x01, Local0)
                    While (Local0)
                    {
                        SMBR (0xFF00, 0x4D, 0x0101, 0x7C00, 0xB2)
                        And (\_SB.MEM.OEAX, 0xFF00, Local1)
                        If (Local1)
                        {
                            And (\_SB.MEM.OEAX, 0xFF, Local1)
                            If (LNot (LEqual (Local1, 0x20)))
                            {
                                Store (0x00, Local0)
                            }
                        }
                        Else
                        {
                            Store (0x00, Local0)
                        }
                    }
                }
            }

            Method (BTPO, 0, NotSerialized)
            {
                If (\_SB.MEM.BTMD)
                {
                    Store (0x00, \_SB.MEM.IEDI)
                    Store (0x01, \_SB.MEM.IESI)
                    SMBR (0xFF00, 0x4D, 0x01, 0x7C00, 0xB2)
                    Store (0x01, Local0)
                    While (Local0)
                    {
                        SMBR (0xFF00, 0x4D, 0x0101, 0x7C00, 0xB2)
                        And (\_SB.MEM.OEAX, 0xFF00, Local1)
                        If (Local1)
                        {
                            And (\_SB.MEM.OEAX, 0xFF, Local1)
                            If (LNot (LEqual (Local1, 0x20)))
                            {
                                Store (0x00, Local0)
                            }
                        }
                        Else
                        {
                            Store (0x00, \_SB.MEM.IEDI)
                            Store (0x14, \_SB.MEM.IESI)
                            SMBR (0xFF00, 0x4D, 0x01, 0x7C00, 0xB2)
                            Store (0x01, Local2)
                            While (Local2)
                            {
                                SMBR (0xFF00, 0x4D, 0x0101, 0x7C00, 0xB2)
                                And (\_SB.MEM.OEAX, 0xFF00, Local3)
                                If (Local3)
                                {
                                    And (\_SB.MEM.OEAX, 0xFF, Local3)
                                    If (LNot (LEqual (Local3, 0x20)))
                                    {
                                        Store (0x00, Local2)
                                    }
                                }
                                Else
                                {
                                    Store (0x00, Local2)
                                }
                            }

                            Store (0x00, Local0)
                        }
                    }
                }
            }

            Method (BTPF, 0, NotSerialized)
            {
                If (\_SB.MEM.BTMD)
                {
                    Store (0x00, \_SB.MEM.IEDI)
                    Store (0x02, \_SB.MEM.IESI)
                    SMBR (0xFF00, 0x4D, 0x01, 0x7C00, 0xB2)
                    Store (0x01, Local0)
                    While (Local0)
                    {
                        SMBR (0xFF00, 0x4D, 0x0101, 0x7C00, 0xB2)
                        And (\_SB.MEM.OEAX, 0xFF00, Local1)
                        If (Local1)
                        {
                            And (\_SB.MEM.OEAX, 0xFF, Local1)
                            If (LNot (LEqual (Local1, 0x20)))
                            {
                                Store (0x00, Local0)
                            }
                        }
                        Else
                        {
                            Store (0x00, \_SB.MEM.IEDI)
                            Store (0x13, \_SB.MEM.IESI)
                            SMBR (0xFF00, 0x4D, 0x01, 0x7C00, 0xB2)
                            Store (0x01, Local2)
                            While (Local2)
                            {
                                SMBR (0xFF00, 0x4D, 0x0101, 0x7C00, 0xB2)
                                And (\_SB.MEM.OEAX, 0xFF00, Local3)
                                If (Local3)
                                {
                                    And (\_SB.MEM.OEAX, 0xFF, Local3)
                                    If (LNot (LEqual (Local3, 0x20)))
                                    {
                                        Store (0x00, Local2)
                                    }
                                }
                                Else
                                {
                                    Store (0x00, Local2)
                                }
                            }

                            Store (0x00, Local0)
                        }
                    }
                }
            }
        }

        Device (LID)
        {
            Name (_HID, EisaId ("PNP0C0D"))
            Method (_LID, 0, NotSerialized)
            {
                Return (\_SB.MEM.LIDS)
            }

            Name (_PRW, Package (0x02)
            {
                0x25,=20
                0x04
            })
            Method (_PSW, 1, NotSerialized)
            {
                If (LEqual (Arg0, 0x00))
                {
                    Store (0x00, \_SB.MEM.EWLD)
                }
                Else
                {
                    Store (0x01, \_SB.MEM.EWLD)
                }
            }
        }

        Device (BAT1)
        {
            Name (_HID, EisaId ("PNP0C0A"))
            Name (_UID, 0x01)
            Name (_PCL, Package (0x01)
            {
                \_SB
            })
            Method (_STA, 0, NotSerialized)
            {
                If (\_SB.MEM.BES1)
                {
                    Return (0x1F)
                }
                Else
                {
                    Return (0x0F)
                }
            }

            Method (_BIF, 0, NotSerialized)
            {
                Name (BUFF, Package (0x0D) {})
                Store (0x00, Index (BUFF, 0x00))
                Store (\_SB.MEM.BDV1, Local2)
                Multiply (\_SB.MEM.BDC1, Local2, Local0)
                Divide (Local0, 0x03E8, Local1, Local0)
                Store (Local0, Index (BUFF, 0x01))
                Multiply (\_SB.MEM.BLF1, Local2, Local0)
                Divide (Local0, 0x03E8, Local1, Local0)
                Store (Local0, Index (BUFF, 0x02))
                Store (\_SB.MEM.BTC1, Index (BUFF, 0x03))
                Store (\_SB.MEM.BDV1, Index (BUFF, 0x04))
                Multiply (\_SB.MEM.BCW1, Local2, Local0)
                Divide (Local0, 0x03E8, Local1, Local0)
                Store (Local0, Index (BUFF, 0x05))
                Multiply (\_SB.MEM.BCL1, Local2, Local0)
                Divide (Local0, 0x03E8, Local1, Local0)
                Store (Local0, Index (BUFF, 0x06))
                Multiply (\_SB.MEM.BG11, Local2, Local0)
                Divide (Local0, 0x03E8, Local1, Local0)
                Store (Local0, Index (BUFF, 0x07))
                Multiply (\_SB.MEM.BG21, Local2, Local0)
                Divide (Local0, 0x03E8, Local1, Local0)
                Store (Local0, Index (BUFF, 0x08))
                Store (\_SB.MEM.BMN1, Index (BUFF, 0x09))
                Store (\_SB.MEM.BSN1, Index (BUFF, 0x0A))
                Store (\_SB.MEM.BTP1, Index (BUFF, 0x0B))
                Store (\_SB.MEM.BOI1, Index (BUFF, 0x0C))
                Return (BUFF)
            }

            Method (_BST, 0, NotSerialized)
            {
                If (\_SB.MEM.BES2)
                {
                    And (\_SB.MEM.BST1, 0x03, Local0)
                    And (\_SB.MEM.BST2, 0x03, Local1)
                    If (LOr (Local0, Local1))
                    {
                        Multiply (\_SB.MEM.BPR1, \_SB.MEM.BDV1, Local0)
                        Divide (Local0, 0x07D0, Local1, Local0)
                    }
                    Else
                    {
                        Store (0x00, Local0)
                    }
                }
                Else
                {
                    If (LAnd (\_SB.MEM.BST1, 0x03))
                    {
                        Multiply (\_SB.MEM.BPR1, \_SB.MEM.BDV1, Local0)
                        Divide (Local0, 0x03E8, Local1, Local0)
                    }
                    Else
                    {
                        Store (0x00, Local0)
                    }
                }

                Name (BUFF, Package (0x04) {})
                Store (\_SB.MEM.BST1, Index (BUFF, 0x00))
                Store (Local0, Index (BUFF, 0x01))
                Multiply (\_SB.MEM.BRC1, \_SB.MEM.BDV1, Local0)
                Divide (Local0, 0x03E8, Local1, Local0)
                Store (Local0, Index (BUFF, 0x02))
                Store (\_SB.MEM.BPV1, Index (BUFF, 0x03))
                Return (BUFF)
            }

            Method (_BTP, 1, NotSerialized)
            {
                Store (0x01, \_SB.MEM.PAR1)
                Store (Arg0, \_SB.MEM.PAR2)
                Store (0x61, \_SB.PCI0.FNC0.SYSR.TRP4)
            }
        }

        Device (BAT2)
        {
            Name (_HID, EisaId ("PNP0C0A"))
            Name (_UID, 0x02)
            Name (_PCL, Package (0x01)
            {
                \_SB
            })
            Method (_STA, 0, NotSerialized)
            {
                If (\_SB.MEM.BES2)
                {
                    Return (0x1F)
                }
                Else
                {
                    Return (0x0F)
                }
            }

            Method (_BIF, 0, NotSerialized)
            {
                Name (BUFF, Package (0x0D) {})
                Store (0x00, Index (BUFF, 0x00))
                Store (\_SB.MEM.BDV2, Local2)
                Multiply (\_SB.MEM.BDC2, Local2, Local0)
                Divide (Local0, 0x03E8, Local1, Local0)
                Store (Local0, Index (BUFF, 0x01))
                Multiply (\_SB.MEM.BLF2, Local2, Local0)
                Divide (Local0, 0x03E8, Local1, Local0)
                Store (Local0, Index (BUFF, 0x02))
                Store (\_SB.MEM.BTC2, Index (BUFF, 0x03))
                Store (\_SB.MEM.BDV2, Index (BUFF, 0x04))
                Multiply (\_SB.MEM.BCW2, Local2, Local0)
                Divide (Local0, 0x03E8, Local1, Local0)
                Store (Local0, Index (BUFF, 0x05))
                Multiply (\_SB.MEM.BCL2, Local2, Local0)
                Divide (Local0, 0x03E8, Local1, Local0)
                Store (Local0, Index (BUFF, 0x06))
                Multiply (\_SB.MEM.BG12, Local2, Local0)
                Divide (Local0, 0x03E8, Local1, Local0)
                Store (Local0, Index (BUFF, 0x07))
                Multiply (\_SB.MEM.BG22, Local2, Local0)
                Divide (Local0, 0x03E8, Local1, Local0)
                Store (Local0, Index (BUFF, 0x08))
                Store (\_SB.MEM.BMN2, Index (BUFF, 0x09))
                Store (\_SB.MEM.BSN2, Index (BUFF, 0x0A))
                Store (\_SB.MEM.BTP2, Index (BUFF, 0x0B))
                Store (\_SB.MEM.BOI2, Index (BUFF, 0x0C))
                Return (BUFF)
            }

            Method (_BST, 0, NotSerialized)
            {
                If (\_SB.MEM.BES1)
                {
                    And (\_SB.MEM.BST1, 0x03, Local0)
                    And (\_SB.MEM.BST2, 0x03, Local1)
                    If (LOr (Local0, Local1))
                    {
                        Multiply (\_SB.MEM.BPR2, \_SB.MEM.BDV2, Local0)
                        Divide (Local0, 0x07D0, Local1, Local0)
                    }
                    Else
                    {
                        Store (0x00, Local0)
                    }
                }
                Else
                {
                    If (LAnd (\_SB.MEM.BST2, 0x03))
                    {
                        Multiply (\_SB.MEM.BPR2, \_SB.MEM.BDV2, Local0)
                        Divide (Local0, 0x03E8, Local1, Local0)
                    }
                    Else
                    {
                        Store (0x00, Local0)
                    }
                }

                Name (BUFF, Package (0x04) {})
                Store (\_SB.MEM.BST2, Index (BUFF, 0x00))
                Store (Local0, Index (BUFF, 0x01))
                Multiply (\_SB.MEM.BRC2, \_SB.MEM.BDV2, Local0)
                Divide (Local0, 0x03E8, Local1, Local0)
                Store (Local0, Index (BUFF, 0x02))
                Store (\_SB.MEM.BPV2, Index (BUFF, 0x03))
                Return (BUFF)
            }

            Method (_BTP, 1, NotSerialized)
            {
                Store (0x02, \_SB.MEM.PAR1)
                Store (Arg0, \_SB.MEM.PAR2)
                Store (0x61, \_SB.PCI0.FNC0.SYSR.TRP4)
            }
        }

        Device (ADP1)
        {
            Name (_HID, "ACPI0003")
            Name (_PCL, Package (0x03)
            {
                \_SB,=20
                \_SB.BAT1,=20
                \_SB.BAT2
            })
            Name (_STA, 0x0F)
            Method (_PSR, 0, NotSerialized)
            {
                Return (\_SB.MEM.ACST)
            }
        }

        Device (VALD)
        {
            Name (_HID, EisaId ("TOS6200"))
            Name (_DDN, "VALD")
            Name (_STA, 0x0B)
            Method (ENAB, 0, NotSerialized)
            {
                Store (0x01, \_SB.MEM.VALF)
                SMBR (0xFF00, 0x16, 0x01, 0x00, 0xB2)
            }

            Method (INFO, 0, NotSerialized)
            {
                Store (0x00, \_SB.MEM.OECX)
                SMBR (0xFE00, 0x16, 0x00, 0x00, 0xB2)
                If (LNot (LEqual (\_SB.MEM.OEAX, 0x00)))
                {
                    Store (0x00, \_SB.MEM.OECX)
                }

                Return (\_SB.MEM.OECX)
            }

            Method (GHCI, 6, Serialized)
            {
                CreateDWordField (Arg0, 0x00, REAX)
                CreateWordField (Arg1, 0x00, R_BX)
                And (REAX, 0xFF00, Local0)
                If (LEqual (Local0, 0xFE00))
                {
                    If (LEqual (R_BX, 0xC000))
                    {
                        Return (G000 (Local0, R_BX, Arg2, Arg3, Arg4, Arg5))
                    }

                    If (LEqual (R_BX, 0xC800))
                    {
                        Return (G800 (Local0, R_BX, Arg2, Arg3, Arg4, Arg5))
                    }

                    If (LEqual (R_BX, 0xC801))
                    {
                        Return (G801 (Local0, R_BX, Arg2, Arg3, Arg4, Arg5))
                    }
                }

                If (LEqual (Local0, 0xFF00))
                {
                    If (LEqual (R_BX, 0xC000))
                    {
                        Return (G000 (Local0, R_BX, Arg2, Arg3, Arg4, Arg5))
                    }

                    If (LEqual (R_BX, 0xC801))
                    {
                        Return (G801 (Local0, R_BX, Arg2, Arg3, Arg4, Arg5))
                    }
                }

                Return (GCH0 (Arg0, Arg1, Arg2, Arg3, Arg4, Arg5))
            }

            Method (GCH0, 6, NotSerialized)
            {
                Store (Arg4, \_SB.MEM.IESI)
                Store (Arg5, \_SB.MEM.IEDI)
                SMBR (Arg0, Arg1, Arg2, Arg3, 0xB2)
                Name (BUFF, Package (0x06) {})
                Store (\_SB.MEM.OEAX, Index (BUFF, 0x00))
                Store (\_SB.MEM.OEBX, Index (BUFF, 0x01))
                Store (\_SB.MEM.OECX, Index (BUFF, 0x02))
                Store (\_SB.MEM.OEDX, Index (BUFF, 0x03))
                Store (\_SB.MEM.OESI, Index (BUFF, 0x04))
                Store (\_SB.MEM.OEDI, Index (BUFF, 0x05))
                Return (BUFF)
            }

            Method (G000, 6, NotSerialized)
            {
                Name (BUFF, Package (0x06) {})
                CreateDWordField (Arg2, 0x00, RECX)
                CreateDWordField (Arg3, 0x00, REDX)
                CreateDWordField (Arg4, 0x00, RESI)
                CreateDWordField (Arg5, 0x00, REDI)
                CreateByteField (Arg2, 0x00, R_CL)
                Store (0x00, Index (BUFF, 0x00))
                Store (Arg1, Index (BUFF, 0x01))
                Store (RECX, Index (BUFF, 0x02))
                Store (REDX, Index (BUFF, 0x03))
                Store (RESI, Index (BUFF, 0x04))
                Store (REDI, Index (BUFF, 0x05))
                If (\_SB.MEM.GCVS)
                {
                    If (LEqual (Arg0, 0xFE00))
                    {
                        If (LEqual (R_CL, 0x00))
                        {
                            Store (\_SB.MEM.TNVS, Local0)
                            Store (Local0, Index (BUFF, 0x02))
                        }
                        Else
                        {
                            If (LAnd (LNot (LLess (R_CL, 0x01)), LNot (LGre=
ater (R_CL, 0x04))))
                            {
                                Store (R_CL, Local0)
                                Or (Local0, 0x3000, Local0)
                                SMBR (0xFA00, Local0, 0x00, 0x00, 0xB2)
                                Store (\_SB.MEM.OECX, Index (BUFF, 0x02))
                                Store (\_SB.MEM.OEDX, Index (BUFF, 0x03))
                            }
                            Else
                            {
                                If (LEqual (R_CL, 0x05))
                                {
                                    Store (0x21, Index (BUFF, 0x02))
                                }
                                Else
                                {
                                    Store (0x8300, Index (BUFF, 0x00))
                                }
                            }
                        }
                    }
                    Else
                    {
                        CreateWordField (Arg3, 0x00, R_DX)
                        If (LEqual (R_CL, 0x00))
                        {
                            If (LEqual (R_DX, 0x00))
                            {
                                Store (0x00, \_SB.MEM.TNVS)
                            }
                            Else
                            {
                                Store (0x01, \_SB.MEM.TNVS)
                            }
                        }
                        Else
                        {
                            If (LEqual (R_CL, 0x01))
                            {
                                Store (R_CL, Local0)
                                Or (Local0, 0x3080, Local0)
                                SMBR (0xFA00, Local0, R_DX, 0x00, 0xB2)
                            }
                            Else
                            {
                                If (LEqual (R_CL, 0x02))
                                {
                                    FindSetRightBit (R_DX, Local0)
                                    Store (Local0, \_SB.MEM.NXDD)
                                    If (LLess (\_SB.MEM.OSID, 0x03))
                                    {
                                        Or (Local0, 0x0100, Local0)
                                        SMBR (0xFF00, 0x1C, Local0, 0x00, 0=
xB2)
                                        And (\_SB.MEM.OEAX, 0xFF00, Local0)
                                        If (LEqual (Local0, 0x00))
                                        {
                                            Store (0x80, Local0)
                                            While (LEqual (Local0, 0x80))
                                            {
                                                SMBR (0xFE00, 0x1C, 0x00, 0=
x00, 0xB2)
                                                And (\_SB.MEM.OECX, 0x80, L=
ocal0)
                                            }

                                            If (\_SB.MEM.CTLA)
                                            {
                                                If (LEqual (\_SB.MEM.LCDS, =
0x00))
                                                {
                                                    SMBR (0xFF00, 0x02, 0x0=
1, 0x00, 0xB2)
                                                    Store (0x01, \_SB.MEM.O=
EDX)
                                                    While (\_SB.MEM.OEDX)
                                                    {
                                                        SMBR (0xFE00, 0x02,=
 0x00, 0x00, 0xB2)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    Else
                                    {
                                        Notify (\_SB.PCI0.PCI1.VGA, 0x80)
                                    }
                                }
                                Else
                                {
                                    Store (0x8300, Index (BUFF, 0x00))
                                }
                            }
                        }
                    }
                }
                Else
                {
                    Store (0x8000, Index (BUFF, 0x00))
                }

                Return (BUFF)
            }

            Method (G800, 6, NotSerialized)
            {
                Store (\_SB.MEM.OSPC, Local0)
                Name (BUFF, Package (0x06) {})
                CreateDWordField (Arg3, 0x00, REDX)
                CreateDWordField (Arg4, 0x00, RESI)
                CreateDWordField (Arg5, 0x00, REDI)
                Store (0x00, Index (BUFF, 0x00))
                Store (Arg1, Index (BUFF, 0x01))
                Store (Local0, Index (BUFF, 0x02))
                Store (REDX, Index (BUFF, 0x03))
                Store (RESI, Index (BUFF, 0x04))
                Store (REDI, Index (BUFF, 0x05))
                Return (BUFF)
            }

            Method (G801, 6, NotSerialized)
            {
                CreateDWordField (Arg2, 0x00, RECX)
                CreateDWordField (Arg3, 0x00, REDX)
                CreateDWordField (Arg4, 0x00, RESI)
                CreateDWordField (Arg5, 0x00, REDI)
                Store (0x8300, Local0)
                Store (RECX, Local1)
                If (LEqual (REDX, 0x01))
                {
                    Store (0x00, Local0)
                    If (LEqual (Arg0, 0xFE00))
                    {
                        Store (\_SB.MEM.PULD, Local1)
                        Store (\_SB.MEM.PULA, Local2)
                        ShiftLeft (Local2, 0x08, Local2)
                        Or (Local1, Local2, Local1)
                    }
                    Else
                    {
                        And (Local1, 0xFF, Local2)
                        ShiftRight (Local1, 0x08, Local3)
                        Store (Local2, \_SB.MEM.PULD)
                        Store (Local3, \_SB.MEM.PULA)
                    }
                }

                If (LEqual (REDX, 0x02))
                {
                    Store (0x00, Local0)
                    If (LEqual (Arg0, 0xFE00))
                    {
                        Store (\_SB.MEM.BCLD, Local1)
                        Store (\_SB.MEM.BCLA, Local2)
                        ShiftLeft (Local2, 0x08, Local2)
                        Or (Local1, Local2, Local1)
                    }
                    Else
                    {
                        And (Local1, 0xFF, Local2)
                        ShiftRight (Local1, 0x08, Local3)
                        Store (Local2, \_SB.MEM.BCLD)
                        Store (Local3, \_SB.MEM.BCLA)
                    }
                }

                Name (BUFF, Package (0x06) {})
                Store (Local0, Index (BUFF, 0x00))
                Store (Arg1, Index (BUFF, 0x01))
                Store (Local1, Index (BUFF, 0x02))
                Store (REDX, Index (BUFF, 0x03))
                Store (RESI, Index (BUFF, 0x04))
                Store (REDI, Index (BUFF, 0x05))
                Return (BUFF)
            }
        }

        Device (VALG)
        {
            Name (_HID, EisaId ("TOS6202"))
            Name (_DDN, "VALGeneral")
            Name (_STA, 0x0B)
            Method (VCID, 0, NotSerialized)
            {
                Store (0x00, \_SB.MEM.RDID)
                Store (0x05, \_SB.PCI0.FNC0.SYSR.TRP4)
                Return (\_SB.MEM.RDID)
            }

            Method (VUID, 0, NotSerialized)
            {
                Store (0x00, \_SB.MEM.RDSN)
                Store (0x05, \_SB.PCI0.FNC0.SYSR.TRP4)
                Return (\_SB.MEM.RDSN)
            }

            Method (VDCK, 1, NotSerialized)
            {
                If (Arg0)
                {
                    Store (0x05, \_SB.PCI0.FNC0.SYSR.TRP4)
                    If (\_SB.MEM.PAR1)
                    {
                        Store (0x41, \_SB.PCI0.FNC0.SYSR.TRP4)
                        Reset (\_SB.PCI0.DKSQ)
                        Wait (\_SB.PCI0.DKSQ, 0x0BB8)
                        Notify (\_SB.PCI0.PCI1.VGA, 0x80)
                        DIS (0x23)
                        Return (One)
                    }

                    Return (Zero)
                }
                Else
                {
                    Return (One)
                }
            }

            Method (VEJ0, 1, NotSerialized)
            {
                If (LOr (\_SB.MEM.BES1, \_SB.MEM.BES2))
                {
                    Store (0x40, \_SB.PCI0.FNC0.SYSR.TRP4)
                    Reset (\_SB.PCI0.DKSQ)
                    Wait (\_SB.PCI0.DKSQ, 0x1388)
                    Notify (\_SB.PCI0.PCI1.VGA, 0x80)
                }
            }

            Method (DLSZ, 0, NotSerialized)
            {
                Return (0x04)
            }

            Method (DLIB, 0, NotSerialized)
            {
                Name (BUFF, Buffer (0x40)
                {
                    0x80, 0x00, 0x07, 0x06, 0xFF, 0xA0, 0x00, 0x00,=20
                    0x79, 0x11, 0x17, 0x06, 0x00, 0x00, 0x00, 0x00,=20
                    0x80, 0x00, 0x00, 0x00, 0x01, 0x10, 0x00, 0x00,=20
                    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,=20
                    0x80, 0x00, 0x00, 0x00, 0x02, 0x10, 0x00, 0x00,=20
                    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,=20
                    0x80, 0x00, 0x00, 0x00, 0x02, 0x60, 0x00, 0x00,=20
                    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
                })
                Store (\_SB.PCI0.USB1.UVI1, Local0)
                CreateByteField (BUFF, 0x18, VI1L)
                CreateByteField (BUFF, 0x19, VI1H)
                CreateByteField (BUFF, 0x28, VI2L)
                CreateByteField (BUFF, 0x29, VI2H)
                ShiftRight (Local0, 0x08, Local1)
                And (Local0, 0xFF, Local0)
                Store (Local0, VI1L)
                Store (Local1, VI1H)
                Store (Local0, VI2L)
                Store (Local1, VI2H)
                Store (\_SB.PCI0.USB1.UDI1, Local0)
                CreateByteField (BUFF, 0x1A, DI1L)
                CreateByteField (BUFF, 0x1B, DI1H)
                CreateByteField (BUFF, 0x2A, DI2L)
                CreateByteField (BUFF, 0x2B, DI2H)
                ShiftRight (Local0, 0x08, Local1)
                And (Local0, 0xFF, Local0)
                Store (Local0, DI1L)
                Store (Local1, DI1H)
                Store (Local0, DI2L)
                Store (Local1, DI2H)
                Store (\_SB.PCI0.USB1.UPI1, Local0)
                CreateByteField (BUFF, 0x11, PIC1)
                CreateByteField (BUFF, 0x21, PIC2)
                Store (Local0, PIC1)
                Store (Local0, PIC2)
                Store (\_SB.PCI0.USB1.USC1, Local0)
                CreateByteField (BUFF, 0x12, SCC1)
                CreateByteField (BUFF, 0x22, SCC2)
                Store (Local0, SCC1)
                Store (Local0, SCC2)
                Store (\_SB.PCI0.USB1.UBC1, Local0)
                CreateByteField (BUFF, 0x13, BCC1)
                CreateByteField (BUFF, 0x23, BCC2)
                Store (Local0, BCC1)
                Store (Local0, BCC2)
                If (LAnd (LEqual (\_SB.PCI0.IEEE.IVI0, 0x104C), LEqual (\_S=
B.PCI0.IEEE.IDI0, 0x8023)))
                {
                    Store (\_SB.PCI0.IEEE.IVI0, Local0)
                    CreateByteField (BUFF, 0x38, VI3L)
                    CreateByteField (BUFF, 0x39, VI3H)
                    ShiftRight (Local0, 0x08, Local1)
                    And (Local0, 0xFF, Local0)
                    Store (Local0, VI3L)
                    Store (Local1, VI3H)
                    Store (\_SB.PCI0.IEEE.IDI0, Local0)
                    CreateByteField (BUFF, 0x3A, DI3L)
                    CreateByteField (BUFF, 0x3B, DI3H)
                    ShiftRight (Local0, 0x08, Local1)
                    And (Local0, 0xFF, Local0)
                    Store (Local0, DI3L)
                    Store (Local1, DI3H)
                    Store (\_SB.PCI0.IEEE.IPI0, Local0)
                    CreateByteField (BUFF, 0x31, PIC3)
                    Store (Local0, PIC3)
                    Store (\_SB.PCI0.IEEE.ISC0, Local0)
                    CreateByteField (BUFF, 0x32, SCC3)
                    Store (Local0, SCC3)
                    Store (\_SB.PCI0.IEEE.IBC0, Local0)
                    CreateByteField (BUFF, 0x33, BCC3)
                    Store (Local0, BCC3)
                }
                Else
                {
                    CreateByteField (BUFF, 0x30, VLD3)
                    Store (0x00, VLD3)
                }

                Return (BUFF)
            }

            Method (VNTF, 1, NotSerialized)
            {
                And (Arg0, 0xFFFF, Local0)
                ShiftRight (Arg0, 0x10, Local1)
                If (LEqual (Local1, 0x01))
                {
                    Notify (\_PR.CPU0, Local0)
                }
            }
        }
    }

    Scope (\_TZ)
    {
        PowerResource (PFAN, 0x00, 0x0000)
        {
            Method (_STA, 0, NotSerialized)
            {
                SMBR (0xFA00, 0x2201, 0x00, 0x00, 0xB2)
                If (\_SB.MEM.OECX)
                {
                    Return (One)
                }
                Else
                {
                    Return (0x00)
                }
            }

            Method (_ON, 0, Serialized)
            {
                SMBR (0xFA00, 0x2200, 0xFF, 0x00, 0xB2)
            }

            Method (_OFF, 0, Serialized)
            {
                SMBR (0xFA00, 0x2200, 0x00, 0x00, 0xB2)
            }
        }

        Device (FAN)
        {
            Name (_HID, EisaId ("PNP0C0B"))
            Name (_PR0, Package (0x01)
            {
                \_TZ.PFAN
            })
        }

        ThermalZone (THRM)
        {
            Method (_TMP, 0, NotSerialized)
            {
                If (LNot (LGreater (\_SB.MEM.TMP1, 0x0B4C)))
                {
                    Store (0x0B4C, \_SB.MEM.AST1)
                    Return (0x0B4C)
                }
                Else
                {
                    Store (\_SB.MEM.TMP1, \_SB.MEM.AST1)
                    Return (\_SB.MEM.TMP1)
                }
            }

            Method (_AC0, 0, NotSerialized)
            {
                Return (\_SB.MEM.AC01)
            }

            Method (_AC1, 0, NotSerialized)
            {
                Return (\_SB.MEM.AC11)
            }

            Name (_AL0, Package (0x01)
            {
                \_TZ.FAN
            })
            Name (_AL1, Package (0x01)
            {
                \_TZ.FAN
            })
            Method (_PSV, 0, NotSerialized)
            {
                Return (\_SB.MEM.PSV1)
            }

            Name (_PSL, Package (0x01)
            {
                \_PR.CPU0
            })
            Method (_CRT, 0, NotSerialized)
            {
                Return (\_SB.MEM.CRT1)
            }

            Name (_TC1, 0x09)
            Name (_TC2, 0x02)
            Name (_TSP, 0x0708)
        }
    }

    Scope (\_GPE)
    {
        Method (_L08, 0, Serialized)
        {
            If (\_SB.MEM.GP72)
            {
                Store (0x00, \_SB.MEM.GP72)
                Notify (\_SB.PCI0.FNC0.COM, 0x02)
            }
        }

        Method (_L09, 0, Serialized)
        {
            If (LNot (LEqual (\_SB.PCI0.LAN.PLVI, 0xFFFF)))
            {
                And (\_SB.PCI0.LAN.PMES, 0x80, Local0)
                If (LEqual (Local0, 0x80))
                {
                    Notify (\_SB.PCI0.LAN, 0x02)
                }
            }

            While (LOr (\_SB.MEM.GP73, LOr (\_SB.MEM.GP74, LOr (\_SB.MEM.GP=
75, LOr (\_SB.MEM.GP83, LOr (\_SB.MEM.BWUE, LOr (\_SB.MEM.WUIE, LOr (\_SB.M=
EM.WSF0, \_SB.MEM.WSF1))))))))
            {
                If (\_SB.MEM.GP73)
                {
                    Store (0x00, \_SB.MEM.GP73)
                    Notify (\_SB.PCI0.ASND, 0x02)
                }

                If (\_SB.MEM.GP74)
                {
                    Store (0x00, \_SB.MEM.GP74)
                    Notify (\_SB.PCI0.FNC0.PCC0, 0x02)
                    Notify (\_SB.PCI0.VIY0, 0x02)
                    Notify (\_SB.PCI0.VIY1, 0x02)
                    Notify (\_SB.PCI0.NOV0, 0x02)
                }

                If (\_SB.MEM.GP75)
                {
                    Store (0x00, \_SB.MEM.GP75)
                    Notify (\_SB.PCI0.USB1, 0x02)
                }

                If (\_SB.MEM.GP83)
                {
                    Store (0x00, \_SB.MEM.GP83)
                    Notify (\_SB.PCI0.LAN, 0x02)
                }

                If (\_SB.MEM.BWUE)
                {
                    Store (0x00, \_SB.MEM.BWUE)
                    Notify (\_SB.BT, 0x80)
                }

                If (\_SB.MEM.WUIE)
                {
                    Store (0x00, \_SB.MEM.WUIE)
                    Notify (\_SB.PCI0.IEEE, 0x02)
                }

                If (\_SB.MEM.WSF0)
                {
                    Store (0x00, \_SB.MEM.WSF0)
                    Notify (\_SB.PCI0.MPC0, 0x02)
                }
            }
        }

        Method (_L25, 0, Serialized)
        {
            Store (0xAF, \_SB.MEM.IEDI)
            SMBR (0xFF00, 0x0028B10B, 0x00, 0x00, 0xB2)
            While (LOr (\_SB.MEM.GP50, LOr (\_SB.MEM.GP51, LOr (\_SB.MEM.GP=
52, LOr (\_SB.MEM.GP53, LOr (\_SB.MEM.GP54, LOr (\_SB.MEM.GP60, LOr (\_SB.M=
EM.GP61, LOr (\_SB.MEM.GP62, LOr (\_SB.MEM.GP63, LOr (\_SB.MEM.GP64, LOr (\=
_SB.MEM.GP66, LOr (\_SB.MEM.GP70, LOr (\_SB.MEM.GP71, \_SB.MEM.BPFE))))))))=
))))))
            {
                If (\_SB.MEM.GP50)
                {
                    Store (0x00, \_SB.MEM.GP50)
                    Notify (\_SB.ADP1, 0x80)
                }

                If (\_SB.MEM.GP51)
                {
                    Store (0x00, \_SB.MEM.GP51)
                    If (LEqual (\_SB.MEM.BES2, \_SB.MEM.BT2F))
                    {
                        Notify (\_SB.BAT2, 0x80)
                    }
                    Else
                    {
                        Store (\_SB.MEM.BES2, \_SB.MEM.BT2F)
                        If (\_SB.MEM.BES2)
                        {
                            Notify (\_SB.BAT2, 0x00)
                        }
                        Else
                        {
                            Notify (\_SB.BAT2, 0x01)
                        }
                    }
                }

                If (\_SB.MEM.GP52)
                {
                    Store (0x00, \_SB.MEM.GP52)
                    If (LEqual (\_SB.MEM.BES1, \_SB.MEM.BT1F))
                    {
                        Notify (\_SB.BAT1, 0x80)
                    }
                    Else
                    {
                        Store (\_SB.MEM.BES1, \_SB.MEM.BT1F)
                        If (\_SB.MEM.BES1)
                        {
                            Notify (\_SB.BAT1, 0x00)
                        }
                        Else
                        {
                            Notify (\_SB.BAT1, 0x01)
                        }
                    }
                }

                If (\_SB.MEM.GP53)
                {
                    Store (0x00, \_SB.MEM.GP53)
                    If (LNot (LEqual (\_SB.MEM.TMP1, \_SB.MEM.AST1)))
                    {
                        Notify (\_TZ.THRM, 0x80)
                    }
                }

                If (\_SB.MEM.GP54)
                {
                    Store (0x00, \_SB.MEM.GP54)
                    If (\_SB.MEM.LANA)
                    {
                        Store (0x00, \_SB.MEM.LANA)
                        Notify (\_SB.PCI0.LAN, 0x01)
                    }
                }

                If (\_SB.MEM.GP60)
                {
                    Store (0x00, \_SB.MEM.GP60)
                    SMBR (0x0136FA00, 0x05F3, 0x00, 0x00, 0xB2)
                    And (\_SB.MEM.OEAX, 0xFF00, Local0)
                    If (LOr (LAnd (LEqual (Local0, 0x00), LEqual (\_SB.MEM.=
OECX, 0x00)), LNot (LEqual (Local0, 0x00))))
                    {
                        Notify (\_SB.PCI0.DOCK, 0x00)
                    }
                    Else
                    {
                        Notify (\_SB.VALG, 0x83)
                    }
                }

                If (\_SB.MEM.GP61)
                {
                    Signal (\_SB.PCI0.DKSQ)
                    Store (0x00, \_SB.MEM.GP61)
                    SMBR (0x0136FA00, 0x05F3, 0x00, 0x00, 0xB2)
                    And (\_SB.MEM.OEAX, 0xFF00, Local0)
                    If (LOr (LAnd (LEqual (Local0, 0x00), LEqual (\_SB.MEM.=
OECX, 0x00)), LNot (LEqual (Local0, 0x00))))
                    {
                        Notify (\_SB.PCI0.DOCK, 0x00)
                    }
                    Else
                    {
                        Notify (\_SB.VALG, 0x83)
                    }
                }

                If (\_SB.MEM.GP62)
                {
                    Store (0x00, \_SB.MEM.GP62)
                    SMBR (0x0136FA00, 0x05F3, 0x00, 0x00, 0xB2)
                    And (\_SB.MEM.OEAX, 0xFF00, Local0)
                    If (LOr (LAnd (LEqual (Local0, 0x00), LEqual (\_SB.MEM.=
OECX, 0x00)), LNot (LEqual (Local0, 0x00))))
                    {
                        Notify (\_SB.PCI0.DOCK, 0x01)
                    }
                    Else
                    {
                        Notify (\_SB.VALG, 0x82)
                    }
                }

                If (\_SB.MEM.GP63)
                {
                    Store (0x00, \_SB.MEM.GP63)
                    If (LEqual (\_SB.MEM.DCKF, 0x00))
                    {
                        Store (0x01, \_SB.MEM.DCKF)
                        SMBR (0x0136FA00, 0x05F3, 0x00, 0x00, 0xB2)
                        And (\_SB.MEM.OEAX, 0xFF00, Local0)
                        If (LOr (LAnd (LEqual (Local0, 0x00), LEqual (\_SB.=
MEM.OECX, 0x00)), LNot (LEqual (Local0, 0x00))))
                        {
                            Notify (\_SB.PCI0.DOCK, 0x00)
                        }
                        Else
                        {
                            Notify (\_SB.VALG, 0x81)
                        }
                    }
                    Else
                    {
                        Signal (\_SB.PCI0.DKSQ)
                        Store (0x00, \_SB.MEM.DCKF)
                    }
                }

                If (\_SB.MEM.GP64)
                {
                    Store (0x00, \_SB.MEM.GP64)
                    If (\_SB.MEM.VALF)
                    {
                        Notify (\_SB.VALD, 0x80)
                    }
                    Else
                    {
                        If (\_SB.MEM.SBL0)
                        {
                            Store (0x00, \_SB.MEM.SBL0)
                            SMBR (0xFE00, 0x14, 0x00, 0x00, 0xB2)
                            Store (\_SB.MEM.OECX, \_SB.MEM.BDID)
                            If (LNot (LEqual (\_SB.MEM.OECX, 0x00)))
                            {
                                If (LEqual (\_SB.MEM.OECX, 0x01)) {}
                                Else
                                {
                                    If (LEqual (\_SB.MEM.OECX, 0x04)) {}
                                    Else
                                    {
                                        Notify (\_SB.PCI0.FNC1.IDE1, 0x03)
                                    }
                                }
                            }
                        }

                        If (\_SB.MEM.SBL1)
                        {
                            Store (0x00, \_SB.MEM.SBL1)
                            SMBR (0xFE00, 0x14, 0x00, 0x00, 0xB2)
                            If (LNot (LEqual (\_SB.MEM.OECX, 0x00)))
                            {
                                If (LEqual (\_SB.MEM.OECX, 0x01)) {}
                                Else
                                {
                                    If (LEqual (\_SB.MEM.OECX, 0x04)) {}
                                    Else
                                    {
                                        Notify (\_SB.PCI0.FNC1.IDE1, 0x00)
                                        Sleep (0x64)
                                        Notify (\_SB.PCI0.FNC1.IDE1, 0x01)
                                    }
                                }
                            }
                        }

                        If (\_SB.MEM.SBL2)
                        {
                            Store (0x00, \_SB.MEM.SBL2)
                            If (LNot (LEqual (\_SB.MEM.BDID, 0x00)))
                            {
                                If (LEqual (\_SB.MEM.BDID, 0x01)) {}
                                Else
                                {
                                    If (LEqual (\_SB.MEM.BDID, 0x04)) {}
                                    Else
                                    {
                                        Notify (\_SB.PCI0.FNC1.IDE1, 0x01)
                                    }
                                }
                            }
                        }

                        If (\_SB.MEM.SBL3)
                        {
                            Store (0x00, \_SB.MEM.SBL3)
                        }
                    }
                }

                If (\_SB.MEM.GP66)
                {
                    Store (0x00, \_SB.MEM.GP66)
                    SMBR (0xFE00, 0x14, 0x00, 0x00, 0xB2)
                    If (LNot (LEqual (\_SB.MEM.OECX, 0x00)))
                    {
                        If (LEqual (\_SB.MEM.OECX, 0x01)) {}
                        Else
                        {
                            If (LEqual (\_SB.MEM.OECX, 0x04))
                            {
                                Notify (\_SB.BAT2, 0x00)
                            }
                            Else
                            {
                                Notify (\_SB.PCI0.FNC1.IDE1, 0x00)
                                Sleep (0x64)
                                Notify (\_SB.PCI0.FNC1.IDE1, 0x01)
                            }
                        }
                    }
                }

                If (\_SB.MEM.GP70)
                {
                    Store (0x00, \_SB.MEM.GP70)
                    If (\_SB.MEM.VALF)
                    {
                        Notify (\_SB.VALD, 0x80)
                    }

                    If (LEqual (\_SB.MEM.HKCD, 0x3D))
                    {
                        TRAP (\_SB.MEM.HKCD)
                    }

                    If (LEqual (\_SB.MEM.DOS2, 0x00))
                    {
                        If (LEqual (\_SB.MEM.HKCD, 0x3F))
                        {
                            If (LEqual (\_SB.MEM.TNVS, 0x00))
                            {
                                Notify (\_SB.PCI0.PCI1.VGA, 0x80)
                            }
                        }
                    }
                }

                If (\_SB.MEM.GP71)
                {
                    Store (0x00, \_SB.MEM.GP71)
                    Notify (\_SB.LID, 0x80)
                }

                If (\_SB.MEM.BPFE)
                {
                    Store (0x00, \_SB.MEM.BPFE)
                    Notify (\_SB.BT, 0x90)
                }
            }
        }
    }

    Method (_PTS, 1, NotSerialized)
    {
        If (LOr (LOr (\_SB.MEM.VWE0, \_SB.MEM.VWE1), \_SB.MEM.VWE2))
        {
            Store (0x01, \_SB.MEM.WED2)
        }
        Else
        {
            Store (0x00, \_SB.MEM.WED2)
        }

        Store (\_SB.MEM.ACST, \_SB.MEM.ACBK)
        If (LAnd (LNot (LLess (Arg0, 0x01)), LNot (LGreater (Arg0, 0x04))))
        {
            Store (\_SB.MEM.EWLD, \_SB.MEM.PAR1)
            Store (0x60, \_SB.PCI0.FNC0.SYSR.TRP4)
        }

        And (Arg0, 0x07, Local0)
        Or (Local0, 0x2100, Local0)
        SMBR (0xFA00, Local0, 0x00, 0x00, 0xB2)
    }

    Method (_WAK, 1, NotSerialized)
    {
        And (Arg0, 0x07, Local0)
        Or (Local0, 0x2180, Local0)
        SMBR (0xFA00, Local0, 0x00, 0x00, 0xB2)
        Notify (\_SB.PCI0.FNC1.IDE1, 0x00)
        Store (0x00, \_SB.MEM.RDID)
        Store (0x00, \_SB.MEM.RDSN)
        Store (0x05, \_SB.PCI0.FNC0.SYSR.TRP4)
        If (LEqual (\_SB.MEM.PAR1, 0x00))
        {
            If (LOr (LEqual (0x1B51F351, \_SB.MEM.RDID), LEqual (0x1C51F351=
, \_SB.MEM.RDID)))
            {
                If (LOr (LNot (LEqual (\_SB.MEM.RDID, \_SB.MEM.DLID)), LNot=
 (LEqual (\_SB.MEM.RDSN, \_SB.MEM.DSRN))))
                {
                    SMBR (0x0136FA00, 0x05F3, 0x00, 0x00, 0xB2)
                    And (\_SB.MEM.OEAX, 0xFF00, Local0)
                    If (LOr (LAnd (LEqual (Local0, 0x00), LEqual (\_SB.MEM.=
OECX, 0x00)), LNot (LEqual (Local0, 0x00))))
                    {
                        Notify (\_SB.PCI0.DOCK, 0x00)
                    }
                    Else
                    {
                        Notify (\_SB.VALG, 0x81)
                    }
                }
            }
            Else
            {
                If (LEqual (0x1D51F351, \_SB.MEM.RDID))
                {
                    If (LOr (LNot (LEqual (\_SB.MEM.RDID, \_SB.MEM.DLID)), =
LNot (LEqual (\_SB.MEM.RDSN, \_SB.MEM.DSRN))))
                    {
                        SMBR (0x0136FA00, 0x05F3, 0x00, 0x00, 0xB2)
                        And (\_SB.MEM.OEAX, 0xFF00, Local0)
                        If (LOr (LAnd (LEqual (Local0, 0x00), LEqual (\_SB.=
MEM.OECX, 0x00)), LNot (LEqual (Local0, 0x00))))
                        {
                            Notify (\_SB.PCI0.DOCK, 0x00)
                        }
                        Else
                        {
                            Notify (\_SB.VALG, 0x81)
                        }
                    }
                }
            }
        }
        Else
        {
            If (\_SB.MEM.DLID)
            {
                SMBR (0x0136FA00, 0x05F3, 0x00, 0x00, 0xB2)
                And (\_SB.MEM.OEAX, 0xFF00, Local0)
                If (LOr (LAnd (LEqual (Local0, 0x00), LEqual (\_SB.MEM.OECX=
, 0x00)), LNot (LEqual (Local0, 0x00))))
                {
                    Notify (\_SB.PCI0.DOCK, 0x01)
                }
                Else
                {
                    Notify (\_SB.VALG, 0x83)
                }
            }
        }

        If (LEqual (\_SB.MEM.DOS2, 0x00))
        {
            If (LOr (LNot (LEqual (\_SB.MEM.CTLA, \_SB.MEM.NXLA)), LNot (LE=
qual (\_SB.MEM.CTCA, \_SB.MEM.NXCA))))
            {
                Notify (\_SB.PCI0.PCI1.VGA, 0x80)
            }
            Else
            {
                If (LNot (LEqual (\_SB.MEM.CTTA, \_SB.MEM.NXTA)))
                {
                    Notify (\_SB.PCI0.PCI1.VGA, 0x80)
                }
            }
        }

        DIS (0x14)
        DIS (0x23)
        SMBR (0xFF00, 0x1E, 0x01, 0x00, 0xB2)
        If (LNot (LGreater (\_SB.MEM.OSID, 0x03)))
        {
            While (LEqual (\_SB.MEM.KBCR, 0x00)) {}
        }

        Store (0x01, \_SB.MEM.PAR1)
        Store (0x60, \_SB.PCI0.FNC0.SYSR.TRP4)
        If (LNot (LEqual (\_SB.MEM.ACST, \_SB.MEM.ACBK)))
        {
            Notify (\_PR.CPU0, 0x80)
        }

        Name (BUFF, Package (0x02)
        {
            0x00,=20
            0x01
        })
        If (LEqual (\_SB.MEM.ACST, 0x00))
        {
            And (\_SB.MEM.BST1, 0x04, Local0)
            If (LEqual (Local0, 0x04))
            {
                Store (0x01, Index (BUFF, 0x00))
            }
        }

        Return (BUFF)
    }

    Method (TRAP, 1, NotSerialized)
    {
        Add (Arg0, 0x12340000, Debug)
    }

    Method (SMBR, 5, NotSerialized)
    {
        Store (Arg0, \_SB.MEM.IEAX)
        Store (Arg1, \_SB.MEM.IEBX)
        Store (Arg2, \_SB.MEM.IECX)
        Store (Arg3, \_SB.MEM.IEDX)
        Store (Arg4, \_SB.PCI0.FNC0.SYSR.TRP4)
    }

    Method (STA, 1, NotSerialized)
    {
        Store (Arg0, \_SB.MEM.PAR1)
        Store (0x00, \_SB.MEM.PAR2)
        Store (0x00, \_SB.MEM.PAR3)
        Store (0x00, \_SB.MEM.PAR4)
        Store (0x00, \_SB.MEM.PAR5)
        Store (0x00, \_SB.MEM.PAR6)
        Store (0x01, \_SB.PCI0.FNC0.SYSR.TRP4)
        Return (\_SB.MEM.PAR4)
    }

    Method (CRS, 1, NotSerialized)
    {
        Store (Arg0, \_SB.MEM.PAR1)
        Store (0x00, \_SB.MEM.PAR2)
        Store (0x00, \_SB.MEM.PAR3)
        Store (0x00, \_SB.MEM.PAR4)
        Store (0x00, \_SB.MEM.PAR5)
        Store (0x00, \_SB.MEM.PAR6)
        Store (0x01, \_SB.PCI0.FNC0.SYSR.TRP4)
        If (LEqual (\_SB.MEM.PAR3, 0x00))
        {
            Return (ResourceTemplate ()
            {
            })
        }

        Name (BUFF, Buffer (\_SB.MEM.PAR3) {})
        Store (\_SB.MEM.PRES, BUFF)
        Return (BUFF)
    }

    Method (PRS, 1, NotSerialized)
    {
        Store (Arg0, \_SB.MEM.PAR1)
        Store (0x01, \_SB.MEM.PAR2)
        Store (0x00, \_SB.MEM.PAR3)
        Store (0x00, \_SB.MEM.PAR4)
        Store (0x00, \_SB.MEM.PAR5)
        Store (0x00, \_SB.MEM.PAR6)
        Store (0x01, \_SB.PCI0.FNC0.SYSR.TRP4)
        If (LEqual (\_SB.MEM.PAR3, 0x00))
        {
            Return (ResourceTemplate ()
            {
            })
        }

        Name (BUFF, Buffer (\_SB.MEM.PAR3) {})
        Store (\_SB.MEM.PRES, BUFF)
        Return (BUFF)
    }

    Method (SRS, 2, NotSerialized)
    {
        Store (Arg0, \_SB.MEM.PAR1)
        Store (0x00, \_SB.MEM.PAR2)
        Store (0x00, \_SB.MEM.PAR3)
        Store (0x00, \_SB.MEM.PAR4)
        Store (0x00, \_SB.MEM.PAR5)
        Store (0x00, \_SB.MEM.PAR6)
        Store (Arg1, \_SB.MEM.PRES)
        Store (0x02, \_SB.PCI0.FNC0.SYSR.TRP4)
    }

    Method (DIS, 1, NotSerialized)
    {
        Store (Arg0, \_SB.MEM.PAR1)
        Store (0x00, \_SB.MEM.PAR2)
        Store (0x00, \_SB.MEM.PAR3)
        Store (0x00, \_SB.MEM.PAR4)
        Store (0x00, \_SB.MEM.PAR5)
        Store (0x00, \_SB.MEM.PAR6)
        Store (0x03, \_SB.PCI0.FNC0.SYSR.TRP4)
    }

    Method (PS0, 1, NotSerialized)
    {
        Store (0x00, \_SB.MEM.IESI)
        SMBR (0xFE00, 0x23, Arg0, 0x00, 0xB2)
        If (LEqual (\_SB.MEM.OEAX, 0x00))
        {
            Store (0x00, \_SB.MEM.IESI)
            SMBR (0xFF00, 0x23, Arg0, 0x00, 0xB2)
            WPSX (Arg0, 0x00, 0x00, 0x00)
        }
    }

    Method (PS3, 1, NotSerialized)
    {
        Store (0x00, \_SB.MEM.IESI)
        SMBR (0xFE00, 0x23, Arg0, 0x00, 0xB2)
        If (LEqual (\_SB.MEM.OEAX, 0x00))
        {
            Store (0x00, \_SB.MEM.IESI)
            SMBR (0xFF00, 0x23, Arg0, 0x03, 0xB2)
            WPSX (Arg0, 0x00, 0x00, 0x03)
        }
    }

    Method (WPSX, 4, NotSerialized)
    {
        Store (Arg1, \_SB.MEM.IESI)
        Store (Arg2, \_SB.MEM.IEDI)
        SMBR (0xFE00, 0x23, Arg0, 0x00, 0xB2)
        While (LNot (LEqual (\_SB.MEM.OECX, 0x00)))
        {
            Store (Arg1, \_SB.MEM.IESI)
            Store (Arg2, \_SB.MEM.IEDI)
            SMBR (0xFE00, 0x23, Arg0, 0x00, 0xB2)
        }
    }

    Method (PSC, 1, NotSerialized)
    {
        Store (0x00, \_SB.MEM.IESI)
        SMBR (0xFE00, 0x23, Arg0, 0x00, 0xB2)
        Return (\_SB.MEM.OEDX)
    }

    Method (CMPS, 2, NotSerialized)
    {
        If (LEqual (SizeOf (Arg0), SizeOf (Arg1)))
        {
            Return (One)
        }
        Else
        {
            Return (Zero)
        }
    }

    Method (STAL, 1, NotSerialized)
    {
        If (LEqual (Arg0, 0x00))
        {
            Return (0x09)
        }
        Else
        {
            Return (0x0B)
        }
    }

    Method (CRSL, 1, NotSerialized)
    {
        Name (IRQB, ResourceTemplate ()
        {
            IRQ (Level, ActiveLow, Shared)
                {}
        })
        CreateWordField (IRQB, 0x01, INTX)
        If (LNot (LEqual (Arg0, 0x00)))
        {
            Name (IRQT, Package (0x10)
            {
                0x00,=20
                0x0200,=20
                0x08,=20
                0x0400,=20
                0x10,=20
                0x20,=20
                0x80,=20
                0x40,=20
                0x02,=20
                0x0800,=20
                0x00,=20
                0x1000,=20
                0x00,=20
                0x4000,=20
                0x00,=20
                0x8000
            })
            Store (DerefOf (Index (IRQT, Arg0)), Local0)
            Store (Local0, INTX)
        }

        Return (IRQB)
    }

    Mutex (MTEX, 0x00)
}


--Boundary-01=_+eaSHugZpVwV/8S--

--nextPart4086140.8zpSNHU8Od
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHSae+R6LMutpd94wRAh/BAJ9y/2S4Mc9w9HMoHggFj0lgZXsMBQCeIm1D
zpLPoHYBxsa4oH2C/SeEG6U=
=GhuN
-----END PGP SIGNATURE-----

--nextPart4086140.8zpSNHU8Od--
