Return-Path: <linux-kernel-owner+w=401wt.eu-S1758249AbZKRUVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249AbZKRUVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 15:21:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932129AbZKRUVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 15:21:04 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:38432 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758170AbZKRUVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 15:21:04 -0500
Date: Wed, 18 Nov 2009 15:21:09 -0500
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Valdis.Kletnieks@vt.edu,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Matteo Croce <technoboy85@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091118202109.GJ15159@caffeine.csclub.uwaterloo.ca>
References: <20091113162301.GU15157@caffeine.csclub.uwaterloo.ca> <20091113165730.0b9b2676@lxorguk.ukuu.org.uk> <20091113192412.GY15157@caffeine.csclub.uwaterloo.ca> <20091113212148.5cb829d4@lxorguk.ukuu.org.uk> <20091116175006.GA15157@caffeine.csclub.uwaterloo.ca> <20091117115929.4ba23c49@lxorguk.ukuu.org.uk> <7332.1258476527@turing-police.cc.vt.edu> <20091117172515.GI15159@caffeine.csclub.uwaterloo.ca> <4B02DE4E.4070504@zytor.com> <20091117183357.GH15157@caffeine.csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117183357.GH15157@caffeine.csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 01:33:57PM -0500, Lennart Sorensen wrote:
> # strace ./rdmsr -x 0x00001810
> execve("./rdmsr", ["./rdmsr", "-x", "0x00001810"], [/* 13 vars */]) = 0
> uname({sys="Linux", node="ruggedrouter", ...}) = 0
> brk(0)                                  = 0x8106000
> access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
> mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f23000
> access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
> mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f22000
> open("/etc/ld.so.cache", O_RDONLY)      = 3
> fstat64(3, {st_mode=S_IFREG|0644, st_size=14975, ...}) = 0
> mmap2(NULL, 14975, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f1e000
> close(3)                                = 0
> access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
> open("/lib/tls/libc.so.6", O_RDONLY)    = 3
> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\240O\1"..., 512) = 512
> fstat64(3, {st_mode=S_IFREG|0644, st_size=1245488, ...}) = 0
> mmap2(NULL, 1251484, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7dec000
> mmap2(0xb7f14000, 28672, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x128) = 0xb7f14000
> mmap2(0xb7f1b000, 10396, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7f1b000
> close(3)                                = 0
> mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7deb000
> mprotect(0xb7f14000, 20480, PROT_READ)  = 0
> set_thread_area({entry_number:-1 -> 6, base_addr:0xb7deb6c0, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0
> munmap(0xb7f1e000, 14975)               = 0
> open("/dev/cpu/0/msr", O_RDONLY|O_LARGEFILE) = 3
> pread64(3, 0xbf83ac00, 8, 6160)         = -1 EIO (Input/output error)
> write(2, "rdmsr: CPU 0 cannot read MSR 0x0"..., 40rdmsr: CPU 0 cannot read MSR 0x00001810
> ) = 40
> exit_group(4)                           = ?
> Process 15044 detached

OK, I added a bit of debuging print statements to msr.c and I find that
calling rdmsr 0x1810 returns error 0xfffffff2 (-14 that is).

It seems to end up calling:

static inline unsigned long long native_read_msr_safe(unsigned int msr,
                                                      int *err)
{
        DECLARE_ARGS(val, low, high);

        asm volatile("2: rdmsr ; xor %0,%0\n"
                     "1:\n\t"
                     ".section .fixup,\"ax\"\n\t"
                     "3:  mov %3,%0 ; jmp 1b\n\t"
                     ".previous\n\t"
                     _ASM_EXTABLE(2b, 3b)
                     : "=r" (*err), EAX_EDX_RET(val, low, high)
                     : "c" (msr), "i" (-EFAULT));
        return EAX_EDX_VAL(val, low, high);
}

That unfortunately is too low level for me to make sense of.

-- 
Len Sorensen
