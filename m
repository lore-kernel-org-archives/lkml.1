Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbZHTLvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbZHTLvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 07:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbZHTLvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 07:51:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:47292 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753991AbZHTLvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 07:51:23 -0400
Cc: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
       rusty@rustcorp.com.au
Content-Type: text/plain; charset="iso-8859-1"
Date: Thu, 20 Aug 2009 13:51:22 +0200
From: "Helge Deller" <deller@gmx.de>
In-Reply-To: <1250640565.15079.3.camel@mulgrave.site>
Message-ID: <20090820115122.123520@gmx.net>
MIME-Version: 1.0
References: <4A89CC4D.5040801@gmx.de>	 <1250549376.7858.96.camel@mulgrave.site>
	 <200908181248.52572.rusty@rustcorp.com.au>	
 <20090818050637.4C3E74730F@magilla.sf.frob.com>
 <1250640565.15079.3.camel@mulgrave.site>
Subject: Re: kernel segv with 2.6.31-rc6 ?
To: James Bottomley <James.Bottomley@HansenPartnership.com>, roland@redhat.com
X-Authenticated: #1045983
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19XcWZ0YdtXxZxIHsiMjbz+G+ER0dA6mNhEyjKl/s
 F5RVU53ww4pQwr+XrumWPzKIbiXyb9O2F3zg== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: 3FzlB3tRbHIhea3NNjQ0QZkiJihyatAC
X-FuHaFi: 0.52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 2009-08-17 at 22:06 -0700, Roland McGrath wrote:
> > > I'd be happy to fail to load it.  There might be sysfs issues with it
> too.
> > 
> > That sounds reasonable to me.  And I'd be happy to at least look a
> little
> > and maybe give some advice to anybody who finds themself building such a
> > (free) module, doesn't know why or how it got that way, and wants to
> ask.
> 
> Actually, for parisc, its not reasonable.  It's expected that our
> modules have multiple text sections (we have to use -ffunction-sections
> to generate them in order that the PCREL17 jump stubs can be
> interleaved).
> 
> The problem looks to be that some linker error gave the one of the named
> function text sections a duplicate name.  Helge, can you post he objdump
> info that shows which section had a duplicate name?
> 
> Even with the duplicate name, though, the module should be perfectly
> loadable.


It's the ac97_bus kernel module:
-rw-r--r-- 1 root root 3.0K 2009-08-19 12:25 ac97_bus.ko 


"objdump -x ac97_bus.ko" shows two .text sections:

ac97_bus.ko:     file format elf32-hppa-linux
ac97_bus.ko                                  
architecture: hppa1.1, flags 0x00000011:     
HAS_RELOC, HAS_SYMS                          
start address 0x00000000                     

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .note.gnu.build-id 00000024  00000000  00000000  00000034  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA            
  1 .text         00000000  00000000  00000000  00000058  2**0     
                  CONTENTS, ALLOC, LOAD, READONLY, CODE            
  2 .text.ac97_bus_match 0000001c  00000000  00000000  00000058  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE              
  3 .exit.text    00000030  00000000  00000000  00000074  2**2       
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE       
  4 .init.text    00000030  00000000  00000000  000000a4  2**2       
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE       
  5 .text         00000000  00000000  00000000  000000d4  2**0       
                  CONTENTS, ALLOC, LOAD, READONLY, CODE              
  6 .rodata.str1.4 00000008  00000000  00000000  000000d4  2**2      
                  CONTENTS, ALLOC, LOAD, READONLY, DATA              
  7 .modinfo      00000040  00000000  00000000  000000dc  2**2       
                  CONTENTS, ALLOC, LOAD, READONLY, DATA              
  8 __ksymtab     00000008  00000000  00000000  0000011c  2**2       
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, DATA       
  9 __ksymtab_strings 0000000e  00000000  00000000  00000124  2**0   
                  CONTENTS, ALLOC, LOAD, READONLY, DATA              
 10 .PARISC.unwind 00000030  00000000  00000000  00000134  2**2      
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, DATA       
 11 .data         00000034  00000000  00000000  00000164  2**2       
                  CONTENTS, ALLOC, LOAD, RELOC, DATA                 
 12 .gnu.linkonce.this_module 00000160  00000000  00000000  00000198  2**2
                  CONTENTS, ALLOC, LOAD, RELOC, DATA, LINK_ONCE_DISCARD   
 13 .bss          00000000  00000000  00000000  000002f8  2**0            
                  ALLOC                                                   
 14 .comment      0000003a  00000000  00000000  000002f8  2**0            
                  CONTENTS, READONLY                                      
SYMBOL TABLE:                                                             
00000000 l    d  .note.gnu.build-id     00000000 .note.gnu.build-id       
00000000 l    d  .text  00000000 .text                                    
00000000 l    d  .text.ac97_bus_match   00000000 .text.ac97_bus_match     
00000000 l    d  .exit.text     00000000 .exit.text                       
00000000 l    d  .init.text     00000000 .init.text                       
00000000 l    d  .text  00000000 .text                                    
00000000 l    d  .rodata.str1.4 00000000 .rodata.str1.4                   
00000000 l    d  .modinfo       00000000 .modinfo                         
00000000 l    d  __ksymtab      00000000 __ksymtab                        
00000000 l    d  __ksymtab_strings      00000000 __ksymtab_strings        
00000000 l    d  .PARISC.unwind 00000000 .PARISC.unwind                   
00000000 l    d  .data  00000000 .data                                    
00000000 l    d  .gnu.linkonce.this_module      00000000 .gnu.linkonce.this_module
00000000 l    d  .bss   00000000 .bss                                             
00000000 l    d  .comment       00000000 .comment                                 
00000000 l     F .text.ac97_bus_match   0000001c ac97_bus_match                   
00000000 l     F .exit.text     00000030 ac97_bus_exit                            
00000000 l     F .init.text     00000030 ac97_bus_init                            
00000000 l     O .modinfo       0000000c __mod_license77                          
00000000 l     O __ksymtab      00000008 __ksymtab_ac97_bus_type                  
00000000 l     O __ksymtab_strings      0000000e __kstrtab_ac97_bus_type          
0000000c l     O .modinfo       00000009 __module_depends                         
00000018 l     O .modinfo       00000026 __mod_vermagic5                          
00000000 g     O .gnu.linkonce.this_module      00000160 __this_module            
00000000 g     F .exit.text     00000030 cleanup_module                           
00000000 g     F .init.text     00000030 init_module                              
00000000         *UND*  00000000 bus_unregister                                   
00000000 g     O .data  00000034 ac97_bus_type                                    
00000000         *UND*  00000000 bus_register                                     


RELOCATION RECORDS FOR [.exit.text]:
OFFSET   TYPE              VALUE
00000010 R_PARISC_DPREL21L  ac97_bus_type
00000014 R_PARISC_DPREL14R  ac97_bus_type
00000018 R_PARISC_PCREL17F  bus_unregister


RELOCATION RECORDS FOR [.init.text]:
OFFSET   TYPE              VALUE
00000010 R_PARISC_DPREL21L  ac97_bus_type
00000014 R_PARISC_DPREL14R  ac97_bus_type
00000018 R_PARISC_PCREL17F  bus_register


RELOCATION RECORDS FOR [__ksymtab]:
OFFSET   TYPE              VALUE
00000000 R_PARISC_DIR32    ac97_bus_type
00000004 R_PARISC_DIR32    __ksymtab_strings


RELOCATION RECORDS FOR [.PARISC.unwind]:
OFFSET   TYPE              VALUE
00000000 R_PARISC_SEGREL32  ac97_bus_match
00000004 R_PARISC_SEGREL32  .text.ac97_bus_match+0x00000018
00000010 R_PARISC_SEGREL32  ac97_bus_exit
00000014 R_PARISC_SEGREL32  .exit.text+0x0000002c
00000020 R_PARISC_SEGREL32  ac97_bus_init
00000024 R_PARISC_SEGREL32  .init.text+0x0000002c


RELOCATION RECORDS FOR [.data]:
OFFSET   TYPE              VALUE
00000000 R_PARISC_DIR32    .rodata.str1.4
00000010 R_PARISC_PLABEL32  ac97_bus_match


RELOCATION RECORDS FOR [.gnu.linkonce.this_module]:
OFFSET   TYPE              VALUE
000000d4 R_PARISC_PLABEL32  init_module
00000150 R_PARISC_PLABEL32  cleanup_module


Helge
-- 
GRATIS für alle GMX-Mitglieder: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://portal.gmx.net/de/go/maxdome01
