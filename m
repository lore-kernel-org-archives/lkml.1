Return-Path: <linux-kernel-owner+w=401wt.eu-S1757827AbYAFBoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827AbYAFBoq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 20:44:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755183AbYAFBoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 20:44:37 -0500
Received: from mail.nutech.com ([204.10.18.136]:2002 "EHLO mail.nutech.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041AbYAFBog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 20:44:36 -0500
X-Greylist: delayed 1826 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Jan 2008 20:44:36 EST
Date: Sat,  5 Jan 2008 17:14:08 -0800
Message-Id: <200801051714.AA13500470@mail.nutech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: "mathewss" <mathewss@mail.nutech.com>
Reply-To: <mathewss@mail.nutech.com>
To: <linux-kernel@vger.kernel.org>
Subject: init wont start on VIA EPIA 5000 500mhz board and randomely wont start on VIA EPIA MII 10000
X-Mailer: <IMail v8.22>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been trying to figure this out a while now with printk's all over my kernel as well as adding kdb and tracing the int3 events.

I have tried various 2.6 kernels and so far all i have tried do this.

 My current tests are on 2.6.22.10 

 I have a simple init binary I compiled static that is my init that is loaded into an init file system. I am not using cpio but that did not seem to matter.
---- begin testinit.c
#include <stdio.h>
#include <unistd.h>
int main(int argc, char *argv[])
{
   printf("Hello world!\n");
   sleep(999999999);
}
---- end

 I am using syslunux to start my kernel and appending the follwiing startup command most of this is specific to my true init script but again im using a "hello world" script to debug this for now.

append  debug kidb=early console=ttyS0,384008n initrd=ufoinit.img init=/testinit rw var_size=12M tmp_size=MAX log_size=16M root_size=64M root=/dev/ram0 boot=/dev/hda1,msdos rw pkgpath=/dev/hda1:msdos rw verbose DELAY=0 TEST=0 DEBUG=0 VERBOSE=0 UFO=root,etc,modules

 On an intel CA810EEA 800mhz board or QEMU this runs fine but on the via boards it dies right after "Freeing unused kernel memory: 132k freed"
 
 on the 500mhz board it dies every time on the 800mhz it is random.

 I have noticed that i get the elf binarly loading into user space with some page_faults then I get blasted with do_notify_resume with 0x04 or TIF_SIGPENDING over and over as if its in an infinite loop.

 This begins shortly after load_elf_binary -> clear_user i think right after a page_fault during the clear_user. I dont even know why that signal is being sent on other hardware it never happens.

 I am not even sure what do try next.

 I have been trying to get my distro up on 2.6 for a while now and away from 2.4 but im currently stuck here.

 Any and all suggestions and help welcome..

my kernel config is here

http://pastebin.cross-lfs.org/4561

 Thanks in advance..

 Regards
  Sean Mathews

struct SoftwareProfessional {
   double salary;
   long   lunches;
   float  jobs;
   char   unstable;
   void   work;
   short  tempers;
}; 




________________________________________________________________
Sent via the WebMail system at mail.nutech.com


 
                   
