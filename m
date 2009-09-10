Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbZIJHdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbZIJHdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 03:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbZIJHdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 03:33:17 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48531 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbZIJHdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 03:33:15 -0400
Date: Thu, 10 Sep 2009 09:33:17 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090910073317.GP18599@kernel.dk>
References: <20090908091304.GQ18599@kernel.dk> <1252423398.7746.97.camel@twins> <20090908203409.GJ18599@kernel.dk> <20090909061308.GA28109@elte.hu> <1252486344.28645.18.camel@marge.simson.net> <20090909091009.GR18599@kernel.dk> <20090909115429.GY18599@kernel.dk> <20090909122006.GA18599@kernel.dk> <1252565738.7205.29.camel@laptop> <20090910065856.GL18599@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="rCb8EA+9TsBVtA92"
Content-Disposition: inline
In-Reply-To: <20090910065856.GL18599@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rCb8EA+9TsBVtA92
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 10 2009, Jens Axboe wrote:
> On Thu, Sep 10 2009, Peter Zijlstra wrote:
> > On Wed, 2009-09-09 at 14:20 +0200, Jens Axboe wrote:
> > > 
> > > One thing I also noticed is that when I have logged in, I run xmodmap
> > > manually to load some keymappings (I always tell myself to add this to
> > > the log in scripts, but I suspend/resume this laptop for weeks at the
> > > time and forget before the next boot). With the stock kernel, xmodmap
> > > will halt X updates and take forever to run. With BFS, it returned
> > > instantly. As I would expect.
> > 
> > Can you provide a little more detail (I'm a xmodmap n00b), how does one
> > run xmodmap and maybe provide your xmodmap config?
> 
> Will do, let me get the notebook and strace time it on both bfs and
> mainline.

Here's the result of running perf stat xmodmap .xmodmap-carl on the
notebook. I have attached the .xmodmap-carl file, it's pretty simple. I
have also attached the output of strace -o foo -f -tt xmodmap
.xmodmap-carl when run on 2.6.31-rc9.

2.6.31-rc9-bfs210

 Performance counter stats for 'xmodmap .xmodmap-carl':

     153.994976  task-clock-msecs         #      0.990 CPUs   (scaled from 99.86%)
              0  context-switches         #      0.000 M/sec  (scaled from 99.86%)
              0  CPU-migrations           #      0.000 M/sec  (scaled from 99.86%)
            315  page-faults              #      0.002 M/sec  (scaled from 99.86%)
  <not counted>  cycles                  
  <not counted>  instructions            
  <not counted>  cache-references        
  <not counted>  cache-misses            

    0.155573406  seconds time elapsed

2.6.31-rc9

 Performance counter stats for 'xmodmap .xmodmap-carl':

       8.529265  task-clock-msecs         #      0.001 CPUs 
             23  context-switches         #      0.003 M/sec
              1  CPU-migrations           #      0.000 M/sec
            315  page-faults              #      0.037 M/sec
  <not counted>  cycles                  
  <not counted>  instructions            
  <not counted>  cache-references        
  <not counted>  cache-misses            

   11.804293482  seconds time elapsed


-- 
Jens Axboe


--rCb8EA+9TsBVtA92
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".xmodmap-carl"

!
! This is an `xmodmap' input file for 
!   PC 105 key, wide Delete, tall Enter (XFree86; US) keyboards.
! Automatically generated on Sun Aug 31 20:11:39 2008 by axboe with
! XKeyCaps 2.47; Copyright (c) 1991-1999 Jamie Zawinski; 2005-2006 Christoph Berg.
! http://www.jwz.org/xkeycaps/
!
! This file presupposes that the keyboard is in the default state, and
! may malfunction if it is not.
!
remove Lock    = Caps_Lock
remove Mod4    = Meta_L Meta_R
remove Mod5    = Scroll_Lock

keycode 0x43 =	Escape	XF86_Switch_VT_1
keycode 0x44 =	F2	XF86_Switch_VT_2
keycode 0x45 =	F3	XF86_Switch_VT_3
keycode 0x46 =	F4	XF86_Switch_VT_4
keycode 0x47 =	F5	XF86_Switch_VT_5
keycode 0x48 =	F6	XF86_Switch_VT_6
keycode 0x49 =	F7	XF86_Switch_VT_7
keycode 0x4A =	F8	XF86_Switch_VT_8
keycode 0x4B =	F9	XF86_Switch_VT_9
keycode 0x4C =	F10	XF86_Switch_VT_10
keycode 0x5F =	F11	XF86_Switch_VT_11
keycode 0x60 =	F12	XF86_Switch_VT_12
keycode 0x16 =	BackSpace	Terminate_Server
keycode 0x3F =	KP_Multiply	XF86_ClearGrab
keycode 0x52 =	KP_Subtract	XF86_Prev_VMode
keycode 0x56 =	KP_Add	XF86_Next_VMode
keycode 0x42 =	Control_L
keycode 0x5E =	less	greater	bar	brokenbar	bar	brokenbar
keycode 0x40 =	Alt_L	Meta_L

add    Control = Control_L
add    Mod1    = 0x009C
add    Mod4    = 0x007F 0x0080
add    Mod5    = Mode_switch ISO_Level3_Shift

keycode 0xa6 = Page_Up
keycode 0xa7 = Page_Down

--rCb8EA+9TsBVtA92
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="strace-xmodmap.txt"

4659  09:32:29.464949 execve("/usr/bin/xmodmap", ["xmodmap", ".xmodmap-carl"], [/* 44 vars */]) = 0
4659  09:32:29.465551 brk(0)            = 0x87e2000
4659  09:32:29.465664 access("/etc/ld.so.nohwcap", F_OK) = 0
4659  09:32:29.465771 mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x6ff8a000
4659  09:32:29.465875 access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or directory)
4659  09:32:29.466003 open("/etc/ld.so.cache", O_RDONLY) = 3
4659  09:32:29.466100 fstat64(3, {st_mode=S_IFREG|0644, st_size=80093, ...}) = 0
4659  09:32:29.466243 mmap2(NULL, 80093, PROT_READ, MAP_PRIVATE, 3, 0) = 0x6ff76000
4659  09:32:29.466355 close(3)          = 0
4659  09:32:29.466438 access("/etc/ld.so.nohwcap", F_OK) = 0
4659  09:32:29.466551 open("/usr/lib/libX11.so.6", O_RDONLY) = 3
4659  09:32:29.466654 read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\2604\1\0004\0\0\0\234"..., 512) = 512
4659  09:32:29.466775 fstat64(3, {st_mode=S_IFREG|0644, st_size=971436, ...}) = 0
4659  09:32:29.466913 mmap2(NULL, 975508, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x6fe87000
4659  09:32:29.467000 mprotect(0x6ff71000, 4096, PROT_NONE) = 0
4659  09:32:29.467089 mmap2(0x6ff72000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xea) = 0x6ff72000
4659  09:32:29.467193 mmap2(0x6ff75000, 660, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x6ff75000
4659  09:32:29.467290 close(3)          = 0
4659  09:32:29.467404 access("/etc/ld.so.nohwcap", F_OK) = 0
4659  09:32:29.467504 open("/lib/libc.so.6", O_RDONLY) = 3
4659  09:32:29.467605 read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\320h\1\0004\0\0\0T"..., 512) = 512
4659  09:32:29.467722 fstat64(3, {st_mode=S_IFREG|0755, st_size=1331404, ...}) = 0
4659  09:32:29.467860 mmap2(NULL, 1336944, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x6fd40000
4659  09:32:29.467951 mmap2(0x6fe81000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x141) = 0x6fe81000
4659  09:32:29.468055 mmap2(0x6fe84000, 9840, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x6fe84000
4659  09:32:29.468152 close(3)          = 0
4659  09:32:29.468238 access("/etc/ld.so.nohwcap", F_OK) = 0
4659  09:32:29.468375 open("/usr/lib/libxcb.so.1", O_RDONLY) = 3
4659  09:32:29.468477 read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\200z\0\0004\0\0\0\250"..., 512) = 512
4659  09:32:29.468599 fstat64(3, {st_mode=S_IFREG|0644, st_size=99768, ...}) = 0
4659  09:32:29.468732 mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x6fd3f000
4659  09:32:29.468829 mmap2(NULL, 102676, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x6fd25000
4659  09:32:29.468920 mmap2(0x6fd3d000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x17) = 0x6fd3d000
4659  09:32:29.469026 close(3)          = 0
4659  09:32:29.469112 access("/etc/ld.so.nohwcap", F_OK) = 0
4659  09:32:29.469213 open("/lib/libdl.so.2", O_RDONLY) = 3
4659  09:32:29.469324 read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0 \n\0\0004\0\0\0D"..., 512) = 512
4659  09:32:29.469453 fstat64(3, {st_mode=S_IFREG|0644, st_size=9676, ...}) = 0
4659  09:32:29.469594 mmap2(NULL, 12408, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x6fd21000
4659  09:32:29.469685 mmap2(0x6fd23000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1) = 0x6fd23000
4659  09:32:29.469790 close(3)          = 0
4659  09:32:29.469879 access("/etc/ld.so.nohwcap", F_OK) = 0
4659  09:32:29.469976 open("/usr/lib/libXau.so.6", O_RDONLY) = 3
4659  09:32:29.470077 read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0P\n\0\0004\0\0\0<"..., 512) = 512
4659  09:32:29.470192 fstat64(3, {st_mode=S_IFREG|0644, st_size=9508, ...}) = 0
4659  09:32:29.470341 mmap2(NULL, 12412, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x6fd1d000
4659  09:32:29.470445 mmap2(0x6fd1f000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1) = 0x6fd1f000
4659  09:32:29.470557 close(3)          = 0
4659  09:32:29.470655 access("/etc/ld.so.nohwcap", F_OK) = 0
4659  09:32:29.470753 open("/usr/lib/libXdmcp.so.6", O_RDONLY) = 3
4659  09:32:29.470855 read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0P\16\0\0004\0\0\0\f"..., 512) = 512
4659  09:32:29.470976 fstat64(3, {st_mode=S_IFREG|0644, st_size=16628, ...}) = 0
4659  09:32:29.471112 mmap2(NULL, 19520, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x6fd18000
4659  09:32:29.471204 mmap2(0x6fd1c000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3) = 0x6fd1c000
4659  09:32:29.471320 close(3)          = 0
4659  09:32:29.471450 mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x6fd17000
4659  09:32:29.471555 set_thread_area({entry_number:-1 -> 6, base_addr:0x6fd17a00, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0
4659  09:32:29.471658 open("/dev/urandom", O_RDONLY) = 3
4659  09:32:29.471755 read(3, "\6~R)"..., 4) = 4
4659  09:32:29.471844 close(3)          = 0
4659  09:32:29.471947 mprotect(0x6fd1f000, 4096, PROT_READ) = 0
4659  09:32:29.472055 mprotect(0x6fd23000, 4096, PROT_READ) = 0
4659  09:32:29.472153 mprotect(0x6fd3d000, 4096, PROT_READ) = 0
4659  09:32:29.472344 mprotect(0x6fe81000, 8192, PROT_READ) = 0
4659  09:32:29.472525 mprotect(0x6ff72000, 4096, PROT_READ) = 0
4659  09:32:29.472621 mprotect(0x804e000, 4096, PROT_READ) = 0
4659  09:32:29.472712 mprotect(0x6ffa7000, 4096, PROT_READ) = 0
4659  09:32:29.472794 munmap(0x6ff76000, 80093) = 0
4659  09:32:29.473047 brk(0)            = 0x87e2000
4659  09:32:29.473126 brk(0x8803000)    = 0x8803000
4659  09:32:29.473323 socket(PF_FILE, SOCK_STREAM, 0) = 3
4659  09:32:29.473445 connect(3, {sa_family=AF_FILE, path=@"/tmp/.X11-unix/X0"...}, 20) = 0
4659  09:32:29.473708 getpeername(3, {sa_family=AF_FILE, path=@"/tmp/.X11-unix/X0"...}, [20]) = 0
4659  09:32:29.473878 uname({sys="Linux", node="carl", ...}) = 0
4659  09:32:29.474146 access("/home/axboe/.Xauthority", R_OK) = 0
4659  09:32:29.474257 open("/home/axboe/.Xauthority", O_RDONLY) = 4
4659  09:32:29.474398 fstat64(4, {st_mode=S_IFREG|0600, st_size=115, ...}) = 0
4659  09:32:29.474536 mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x6ff89000
4659  09:32:29.474629 read(4, "\1\0\0\4carl\0\0010\0\22MIT-MAGIC-COOKIE-1\0\20"..., 4096) = 115
4659  09:32:29.474756 read(4, ""..., 4096) = 0
4659  09:32:29.474839 close(4)          = 0
4659  09:32:29.474918 munmap(0x6ff89000, 4096) = 0
4659  09:32:29.475036 fcntl64(3, F_GETFL) = 0x2 (flags O_RDWR)
4659  09:32:29.475124 fcntl64(3, F_SETFL, O_RDWR|O_NONBLOCK) = 0
4659  09:32:29.475205 fcntl64(3, F_SETFD, FD_CLOEXEC) = 0
4659  09:32:29.475313 select(4, [3], [3], NULL, NULL) = 1 (out [3])
4659  09:32:29.475437 writev(3, [{"l\0\v\0\0\0\22\0\20\0\0\0"..., 12}, {""..., 0}, {"MIT-MAGIC-COOKIE-1"..., 18}, {"\0\0"..., 2}, {"\232\346\374\251t\31M}(\306K\276\272\16\354\376"..., 16}, {""..., 0}], 6) = 48
4659  09:32:29.475719 read(3, "\1\0\v\0\0\0\263\1"..., 8) = 8
4659  09:32:29.475823 read(3, "@\276\241\0\0\0`\2\377\377\37\0\0\1\0\0\24\0\377\377\1\7\0\0  \10\377\1\0\0\0T"..., 1740) = 1740
4659  09:32:29.476021 select(4, [3], [3], NULL, NULL) = 1 (out [3])
4659  09:32:29.476122 writev(3, [{"b\0\5\0\f\0\0\0BIG-REQUESTS"..., 20}], 1) = 20
4659  09:32:29.476314 select(4, [3], [], NULL, NULL) = 1 (in [3])
4659  09:32:29.476427 read(3, "\1\0\1\0\0\0\0\0\1\216\0\0\0\0\0\0\24\0\0\0\0\0\0\0p\343%\t\0\0\0\0"..., 4096) = 32
4659  09:32:29.476580 select(4, [3], [3], NULL, NULL) = 1 (out [3])
4659  09:32:29.476680 writev(3, [{"\216\0\1\0"..., 4}], 1) = 4
4659  09:32:29.476843 select(4, [3], [], NULL, NULL) = 1 (in [3])
4659  09:32:29.476940 read(3, "\1\0\2\0\0\0\0\0\377\377?\0\0\0\0\1\0\0\0\0p\343%\t\0\0\0\0\364_\36\10"..., 4096) = 32
4659  09:32:29.477087 read(3, 0x87e2850, 4096) = -1 EAGAIN (Resource temporarily unavailable)
4659  09:32:29.477193 select(4, [3], [3], NULL, NULL) = 1 (out [3])
4659  09:32:29.477306 writev(3, [{"7\0\5\0\0\0`\2#\1\0\0\10\0\0\0\377\377\377\0\24\0\6\0#\1\0\0\27\0\0\0\37"..., 44}, {NULL, 0}, {""..., 0}], 3) = 44
4659  09:32:29.477566 select(4, [3], [], NULL, NULL) = 1 (in [3])
4659  09:32:29.477665 read(3, "\1\10\4\0x\0\0\0\37\0\0\0\0\0\0\0\335\1\0\0``\37\10xs\310w9\2\26\10*"..., 4096) = 512
4659  09:32:29.477802 read(3, 0x87e2850, 4096) = -1 EAGAIN (Resource temporarily unavailable)
4659  09:32:29.477909 select(4, [3], [3], NULL, NULL) = 1 (out [3])
4659  09:32:29.478008 writev(3, [{"b\0\5\0\t\0`\2"..., 8}, {"XKEYBOARD"..., 9}, {"\0\0\0"..., 3}], 3) = 20
4659  09:32:29.478200 select(4, [3], [], NULL, NULL) = 1 (in [3])
4659  09:32:29.478310 read(3, "\1\0\5\0\0\0\0\0\1\220`\231\0\0\0\0\24\0\0\0\0\0\0\0p\343%\t\0\0\0\0"..., 4096) = 32
4659  09:32:29.478459 read(3, 0x87e2850, 4096) = -1 EAGAIN (Resource temporarily unavailable)
4659  09:32:29.478561 select(4, [3], [3], NULL, NULL) = 1 (out [3])
4659  09:32:29.478660 writev(3, [{"\220\0\2\0\1\0\0\0"..., 8}, {NULL, 0}, {""..., 0}], 3) = 8
4659  09:32:29.478841 select(4, [3], [], NULL, NULL) = 1 (in [3])
4659  09:32:29.478938 read(3, "\1\1\6\0\0\0\0\0\1\0\0\0\230\270\30\t\2\0\0\0\10\0\0\0p\343%\t\30\260\350\10"..., 4096) = 32
4659  09:32:29.479072 read(3, 0x87e2850, 4096) = -1 EAGAIN (Resource temporarily unavailable)
4659  09:32:29.479170 select(4, [3], [3], NULL, NULL) = 1 (out [3])
4659  09:32:29.479269 writev(3, [{"w\0\1\0"..., 4}, {NULL, 0}, {""..., 0}], 3) = 4
4659  09:32:29.479475 select(4, [3], [], NULL, NULL) = 1 (in [3])
4659  09:32:29.479577 read(3, "\1\3\7\0\6\0\0\0p\343%\t\0\0\0\0\4\0\0\0\0\0\0\0p\343%\t\0\0\0\0002"..., 4096) = 56
4659  09:32:29.479712 read(3, 0x87e2850, 4096) = -1 EAGAIN (Resource temporarily unavailable)
4659  09:32:29.479804 open(".xmodmap-carl", O_RDONLY) = 4
4659  09:32:29.479905 fstat64(4, {st_mode=S_IFREG|0644, st_size=1365, ...}) = 0
4659  09:32:29.480039 mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x6ff89000
4659  09:32:29.480126 read(4, "!\n! This is an `xmodmap' input fi"..., 4096) = 1365
4659  09:32:29.480305 select(4, [3], [3], NULL, NULL) = 1 (out [3])
4659  09:32:29.480421 writev(3, [{"\220\10\7\0\0\1\7\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 28}, {NULL, 0}, {""..., 0}], 3) = 28
4659  09:32:29.480679 select(4, [3], [], NULL, NULL) = 1 (in [3])
4659  09:32:29.480778 read(3, "\1\1\10\0G\4\0\0\0\0\10\377\7\0\0\31\31\10(\1\370\0\0\0\0\0\0\0\0\0\0\10\370"..., 4096) = 4096
4659  09:32:29.480906 read(3, "\0\0\0\0\0\0\0\0\1\1\1\0006\377\10\20\0\0\0\0\0\0\0\0\0\0\0\0\1\1\1\0i"..., 316) = 316
4659  09:32:29.481043 read(3, 0x87e2850, 4096) = -1 EAGAIN (Resource temporarily unavailable)
4659  09:32:29.481734 open("/usr/share/X11/XKeysymDB", O_RDONLY) = 6
4659  09:32:29.481858 fstat64(6, {st_mode=S_IFREG|0644, st_size=8934, ...}) = 0
4659  09:32:29.481999 read(6, "! $Xorg: XKeysymDB,v 1.3 2000/08/"..., 8934) = 8934
4659  09:32:29.482113 close(6)          = 0
4659  09:32:29.482440 open("/usr/share/X11/locale/locale.alias", O_RDONLY) = 6
4659  09:32:29.482570 fstat64(6, {st_mode=S_IFREG|0644, st_size=80646, ...}) = 0
4659  09:32:29.482705 mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x6ff88000
4659  09:32:29.482793 read(6, "#\t$XdotOrg: lib/X11/nls/locale.al"..., 4096) = 4096
4659  09:32:29.482975 read(6, "br_FR.iso88591\t\t\t\t\tbr_FR.ISO8859-"..., 4096) = 4096
4659  09:32:29.483150 read(6, "9-1\nde_DE.ISO_8859-1\t\t\t\tde_DE.ISO"..., 4096) = 4096
4659  09:32:29.483358 read(6, "-1\nen_ZW.ISO-8859-1\t\t\t\ten_ZW.ISO8"..., 4096) = 4096
4659  09:32:29.483553 read(6, "UTF-8\nfi\t\t\t\t\t\tfi_FI.ISO8859-15\nfi"..., 4096) = 4096
4659  09:32:29.483732 read(6, "1255\nhe_IL.MICROSOFT-CP1255\t\t\t\the"..., 4096) = 4096
4659  09:32:29.483832 read(6, "\tlt_LT.UTF-8\nlv\t\t\t\t\t\tlv_LV.ISO885"..., 4096) = 4096
4659  09:32:29.483930 read(6, "1\t\t\t\tpt_BR.ISO8859-1\npt_BR.ISO_88"..., 4096) = 4096
4659  09:32:29.484024 read(6, "O-8859-1\t\t\t\tsv_FI.ISO8859-1\nsv_FI"..., 4096) = 4096
4659  09:32:29.484124 read(6, "8\nZH_TW.UTF-8\t\t\t\t\tzh_TW.UTF-8\nzu\t"..., 4096) = 4096
4659  09:32:29.484222 read(6, "\tar_AE.ISO8859-6\nar_AE.utf8:\t\t\t\t\t"..., 4096) = 4096
4659  09:32:29.484340 read(6, "5\nca_ES.UTF-8@euro:\t\t\t\tca_ES.UTF-"..., 4096) = 4096
4659  09:32:29.484447 read(6, "_GR.ISO8859-7\nel_GR@euro:\t\t\t\t\tel_"..., 4096) = 4096
4659  09:32:29.484551 read(6, "\tes_DO.ISO8859-1\nes_DO.iso88591:\t"..., 4096) = 4096
4659  09:32:29.484652 read(6, "\t\t\t\tfr_BE.ISO8859-1\nfr_BE.88591.e"..., 4096) = 4096
4659  09:32:29.484751 read(6, "nesian (now id).  These lines sho"..., 4096) = 4096
4659  09:32:29.484853 read(6, "5\nmk_MK.cp1251:\t\t\t\t\tmk_MK.CP1251\n"..., 4096) = 4096
4659  09:32:29.484955 read(6, "15\npt_PT.ISO-8859-15@euro:\t\t\t\tpt_"..., 4096) = 4096
4659  09:32:29.485052 read(6, "E.ISO8859-1\nsv_SE.88591:\t\t\t\t\tsv_S"..., 4096) = 4096
4659  09:32:29.485156 read(6, "zu_ZA.utf8:\t\t\t\t\tzu_ZA.UTF-8\n\n# Th"..., 4096) = 2822
4659  09:32:29.485243 read(6, ""..., 4096) = 0
4659  09:32:29.485288 close(6)          = 0
4659  09:32:29.485349 munmap(0x6ff88000, 4096) = 0
4659  09:32:29.485406 open("/usr/share/X11/locale/locale.dir", O_RDONLY) = 6
4659  09:32:29.485466 fstat64(6, {st_mode=S_IFREG|0644, st_size=39195, ...}) = 0
4659  09:32:29.485539 mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x6ff88000
4659  09:32:29.485590 read(6, "#\t$XdotOrg: lib/X11/nls/locale.di"..., 4096) = 4096
4659  09:32:29.485682 read(6, "ALE:\t\t\teo_EO.ISO8859-3\n# iso8859-"..., 4096) = 4096
4659  09:32:29.485773 read(6, "59-1\niso8859-1/XLC_LOCALE\t\t\tny_NO"..., 4096) = 4096
4659  09:32:29.485864 read(6, "\t\tar_TN.UTF-8\nen_US.UTF-8/XLC_LOC"..., 4096) = 4096
4659  09:32:29.485953 read(6, "/XLC_LOCALE\t\t\tmk_MK.UTF-8\nen_US.U"..., 4096) = 4096
4659  09:32:29.486035 close(6)          = 0
4659  09:32:29.486079 munmap(0x6ff88000, 4096) = 0
4659  09:32:29.486128 access("/usr/share/X11/locale/C/XLC_LOCALE", R_OK) = 0
4659  09:32:29.486190 open("/usr/share/X11/locale/C/XLC_LOCALE", O_RDONLY) = 6
4659  09:32:29.486251 fstat64(6, {st_mode=S_IFREG|0644, st_size=772, ...}) = 0
4659  09:32:29.486342 mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x6ff88000
4659  09:32:29.486389 read(6, "#  $Xorg: C,v 1.3 2000/08/17 19:4"..., 4096) = 772
4659  09:32:29.486512 read(6, ""..., 4096) = 0
4659  09:32:29.486561 close(6)          = 0
4659  09:32:29.486605 munmap(0x6ff88000, 4096) = 0
4659  09:32:29.486720 open("/usr/share/X11/locale/locale.alias", O_RDONLY) = 6
4659  09:32:29.486780 fstat64(6, {st_mode=S_IFREG|0644, st_size=80646, ...}) = 0
4659  09:32:29.486853 mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x6ff88000
4659  09:32:29.486901 read(6, "#\t$XdotOrg: lib/X11/nls/locale.al"..., 4096) = 4096
4659  09:32:29.487000 read(6, "br_FR.iso88591\t\t\t\t\tbr_FR.ISO8859-"..., 4096) = 4096
4659  09:32:29.487094 read(6, "9-1\nde_DE.ISO_8859-1\t\t\t\tde_DE.ISO"..., 4096) = 4096
4659  09:32:29.487189 read(6, "-1\nen_ZW.ISO-8859-1\t\t\t\ten_ZW.ISO8"..., 4096) = 4096
4659  09:32:29.487285 read(6, "UTF-8\nfi\t\t\t\t\t\tfi_FI.ISO8859-15\nfi"..., 4096) = 4096
4659  09:32:29.487398 read(6, "1255\nhe_IL.MICROSOFT-CP1255\t\t\t\the"..., 4096) = 4096
4659  09:32:29.487497 read(6, "\tlt_LT.UTF-8\nlv\t\t\t\t\t\tlv_LV.ISO885"..., 4096) = 4096
4659  09:32:29.487597 read(6, "1\t\t\t\tpt_BR.ISO8859-1\npt_BR.ISO_88"..., 4096) = 4096
4659  09:32:29.487690 read(6, "O-8859-1\t\t\t\tsv_FI.ISO8859-1\nsv_FI"..., 4096) = 4096
4659  09:32:29.487789 read(6, "8\nZH_TW.UTF-8\t\t\t\t\tzh_TW.UTF-8\nzu\t"..., 4096) = 4096
4659  09:32:29.487886 read(6, "\tar_AE.ISO8859-6\nar_AE.utf8:\t\t\t\t\t"..., 4096) = 4096
4659  09:32:29.487987 read(6, "5\nca_ES.UTF-8@euro:\t\t\t\tca_ES.UTF-"..., 4096) = 4096
4659  09:32:29.488085 read(6, "_GR.ISO8859-7\nel_GR@euro:\t\t\t\t\tel_"..., 4096) = 4096
4659  09:32:29.488185 read(6, "\tes_DO.ISO8859-1\nes_DO.iso88591:\t"..., 4096) = 4096
4659  09:32:29.488283 read(6, "\t\t\t\tfr_BE.ISO8859-1\nfr_BE.88591.e"..., 4096) = 4096
4659  09:32:29.488399 read(6, "nesian (now id).  These lines sho"..., 4096) = 4096
4659  09:32:29.488501 read(6, "5\nmk_MK.cp1251:\t\t\t\t\tmk_MK.CP1251\n"..., 4096) = 4096
4659  09:32:29.488604 read(6, "15\npt_PT.ISO-8859-15@euro:\t\t\t\tpt_"..., 4096) = 4096
4659  09:32:29.488709 read(6, "E.ISO8859-1\nsv_SE.88591:\t\t\t\t\tsv_S"..., 4096) = 4096
4659  09:32:29.488812 read(6, "zu_ZA.utf8:\t\t\t\t\tzu_ZA.UTF-8\n\n# Th"..., 4096) = 2822
4659  09:32:29.488899 read(6, ""..., 4096) = 0
4659  09:32:29.488943 close(6)          = 0
4659  09:32:29.488986 munmap(0x6ff88000, 4096) = 0
4659  09:32:29.489038 open("/usr/share/X11/locale/locale.dir", O_RDONLY) = 6
4659  09:32:29.489097 fstat64(6, {st_mode=S_IFREG|0644, st_size=39195, ...}) = 0
4659  09:32:29.489170 mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x6ff88000
4659  09:32:29.489218 read(6, "#\t$XdotOrg: lib/X11/nls/locale.di"..., 4096) = 4096
4659  09:32:29.489318 read(6, "ALE:\t\t\teo_EO.ISO8859-3\n# iso8859-"..., 4096) = 4096
4659  09:32:29.489417 read(6, "59-1\niso8859-1/XLC_LOCALE\t\t\tny_NO"..., 4096) = 4096
4659  09:32:29.489507 read(6, "\t\tar_TN.UTF-8\nen_US.UTF-8/XLC_LOC"..., 4096) = 4096
4659  09:32:29.489599 read(6, "/XLC_LOCALE\t\t\tmk_MK.UTF-8\nen_US.U"..., 4096) = 4096
4659  09:32:29.489680 close(6)          = 0
4659  09:32:29.489723 munmap(0x6ff88000, 4096) = 0
4659  09:32:29.489771 access("/usr/share/X11/locale/C/XLC_LOCALE", R_OK) = 0
4659  09:32:29.489831 open("/usr/share/X11/locale/C/XLC_LOCALE", O_RDONLY) = 6
4659  09:32:29.489890 fstat64(6, {st_mode=S_IFREG|0644, st_size=772, ...}) = 0
4659  09:32:29.489963 mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x6ff88000
4659  09:32:29.490010 read(6, "#  $Xorg: C,v 1.3 2000/08/17 19:4"..., 4096) = 772
4659  09:32:29.490129 read(6, ""..., 4096) = 0
4659  09:32:29.490173 close(6)          = 0
4659  09:32:29.490217 munmap(0x6ff88000, 4096) = 0
4659  09:32:29.490608 read(4, ""..., 4096) = 0
4659  09:32:29.490665 close(4)          = 0
4659  09:32:29.490709 munmap(0x6ff89000, 4096) = 0
4659  09:32:29.490767 select(4, [3], [3], NULL, NULL) = 1 (out [3])
4659  09:32:29.490823 writev(3, [{"\220\1\5\0\1\0\1\0\0\0\0\0\0\0\0\0\5\0\5\0\220\1\4\0\1\0\2\0\0\0\0\0\7"..., 356}, {NULL, 0}, {""..., 0}], 3) = 356
4659  09:32:29.496610 select(4, [3], [], NULL, NULL) = 1 (in [3])
4659  09:32:29.499184 read(3, "`\1\v\0\1\31\6\0\1\0\22\0\10\377\0\0C\1C\1\0\0\0\0\0\0\0\0\0\0\1C`"..., 4096) = 2464
4659  09:32:29.499699 read(3, 0x87e2850, 4096) = -1 EAGAIN (Resource temporarily unavailable)
4659  09:32:29.499929 read(3, 0x87e2850, 4096) = -1 EAGAIN (Resource temporarily unavailable)
4659  09:32:29.500036 read(3, 0x87e2850, 4096) = -1 EAGAIN (Resource temporarily unavailable)
4659  09:32:29.500150 select(4, [3], [3], NULL, NULL) = 1 (out [3])
4659  09:32:29.500339 writev(3, [{"\220\10\7\0\1\0\0\0\2\0\0\0\26K\0\0\0\0\0\0\0\0\0\0\0\0\2\0"..., 28}, {NULL, 0}, {""..., 0}], 3) = 28
4659  09:32:29.500496 select(4, [3], [], NULL, NULL) = 1 (in [3])
4659  09:32:29.504436 read(3, "\1\1\37\0+\1\0\0\0\0\10\377\2\0\0\0\31\26\223\0K\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096) = 1228
4659  09:32:29.504621 read(3, 0x87e2850, 4096) = -1 EAGAIN (Resource temporarily unavailable)
4659  09:32:29.505186 select(4, [3], [3], NULL, NULL) = 1 (out [3])
4659  09:32:29.505244 writev(3, [{"d\1\3\0\246\1\0\0U\377\0\0d\1\3\0\247\1\0\0V\377\0\0v\3\7\0002>\0\0\0"..., 52}, {NULL, 0}, {""..., 0}], 3) = 52
4659  09:32:29.505331 select(4, [3], [], NULL, NULL) = 1 (in [3])
4659  09:32:35.629358 read(3, "`\1 \0\3720\6\0\1\0\22\0\10\377\0\0\246\1\246\1\0\0\0\0\0\0\0\0\0\0\1\246`"..., 4096) = 416
4659  09:32:35.629460 read(3, 0x87e2850, 4096) = -1 EAGAIN (Resource temporarily unavailable)
4659  09:32:35.629527 select(4, [3], [3], NULL, NULL) = 1 (out [3])
4659  09:32:35.629592 writev(3, [{"<\1\2\0\0\0`\2+\377\1\0"..., 12}, {NULL, 0}, {""..., 0}], 3) = 12
4659  09:32:35.629658 select(4, [3], [], NULL, NULL) = 1 (in [3])
4659  09:32:36.638211 read(3, "\1\1$\0\0\0\0\0$\0\300\1\0\0\0\0\4\0\0\0p\0\0\0p\343%\t\0\0\0\0"..., 4096) = 32
4659  09:32:36.638304 read(3, 0x87e2850, 4096) = -1 EAGAIN (Resource temporarily unavailable)
4659  09:32:36.638373 close(3)          = 0
4659  09:32:36.638473 exit_group(1)     = ?

--rCb8EA+9TsBVtA92--
