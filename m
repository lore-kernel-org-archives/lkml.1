Return-Path: <linux-kernel-owner+w=401wt.eu-S1751883Ab0AADII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab0AADII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 22:08:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753Ab0AADIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 22:08:06 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:37111 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab0AADID convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 22:08:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VSHy3QsDqTxC1xDKR8amSHvx+R4UWb6BF507YMKaxFSYrM1klMLk679LssYomN/m45
         EQo4H798ubJXJgECsCChQ7JIVgqXaKrWX2rJG4Cg0gFjo0mvAxUD2XNvofvZDrzv/0y1
         Y9AsbR3ti9Xx73QVRPYde1LC5gbinN8umAyVM=
MIME-Version: 1.0
In-Reply-To: <1262188157.2749.21.camel@mulgrave.site>
References: <87k4w4wux9.fsf@purkki.valot.fi>
	 <1262188157.2749.21.camel@mulgrave.site>
Date: Fri, 1 Jan 2010 11:08:01 +0800
Message-ID: <2375c9f90912311908r667966e1m919430c40cd9c571@mail.gmail.com>
Subject: Re: regression: crash from 'ls /sys/modules/wl1251_spi/notes'
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, linux-omap@vger.kernel.org,
       Helge Deller <deller@gmx.de>, rusty@rustcorp.com.au,
       akpm@linux-foundation.org, roland@redhat.com, dave@hiauly1.hia.nrc.ca,
       Parisc List <linux-parisc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 11:49 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Wed, 2009-12-30 at 13:41 +0200, Kalle Valo wrote:
>> Hello,
>>
>> I noticed weird crashes related to wl1251_spi notes sysfs directory
>> with current wireless-testing (2.6.33-rc2 plus some wireless patches).
>> The simplest way to reproduce the problem is to do this on a nokia n900
>> (arm/omap 3430):
>>
>> # ls /sys/module/wl1251_spi/notes/
>> [ 4776.503234] Unable to handle kernel NULL pointer dereference at
>> virtual address 00000000
>> [ 4776.511596] pgd = cce88000
>> [ 4776.514343] [00000000] *pgd=8f04a031, *pte=00000000, *ppte=00000000
>> [ 4776.520812] Internal error: Oops: 17 [#1]
>> [ 4776.524871] last sysfs file: /sys/class/net/wlan0/flags
>> [ 4776.530151] Modules linked in: wl1251_spi wl1251 mac80211 cfg80211
>> [ 4776.536468] CPU: 0    Not tainted  (2.6.33-rc2-wl-47091-g981eb84
>> #12)
>> [ 4776.542999] PC is at strlen+0xc/0x20
>> [ 4776.546630] LR is at sysfs_readdir+0x15c/0x1e0
>> [ 4776.551116] pc : [<c01476ac>]    lr : [<c00f5e6c>]    psr: a0000013
>> [ 4776.551147] sp : cce87f28  ip : 22222222  fp : be99961c
>> [ 4776.562744] r10: cce87f80  r9 : 00000000  r8 : 00000000
>> [ 4776.568023] r7 : c00b9540  r6 : cce87f80  r5 : ccec4458  r4 :
>> ce808980
>> [ 4776.574615] r3 : 00000000  r2 : 00000002  r1 : 22222222  r0 :
>> 00000000
>> [ 4776.581207] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM
>> Segment user
>> [ 4776.588409] Control: 10c5387d  Table: 8ce88019  DAC: 00000015
>> [ 4776.594238] Process ls (pid: 1148, stack limit = 0xcce862e8)
>> [ 4776.599945] Stack: (0xcce87f28 to 0xcce88000)
>> [ 4776.604370] 7f20:                   00000001 00000000 00000e16
>> 00000000 00000004 22222222
>> [ 4776.612640] 7f40: ce808980 ce808980 cf79e34c c00b9540 00000000
>> cf79e2b8 cce86000 c00b982c
>> [ 4776.620910] 7f60: 00000001 00000000 00001000 000690d0 ce808980
>> c002bae4 00000000 c00b98c4
>> [ 4776.629180] 7f80: 00069100 000690e8 00000fd0 ffffffea 00000000
>> 00000000 00000000 00000000
>> [ 4776.637451] 7fa0: 000000d9 c002b940 00000000 00000000 00000003
>> 000690d0 00001000 00000000
>> [ 4776.645721] 7fc0: 00000000 00000000 00000000 000000d9 000690c8
>> 00000001 00000000 be99961c
>> [ 4776.654022] 7fe0: 400ef954 be999614 400efa10 400ef908 60000010
>> 00000003 80c69021 80c69421
>> [ 4776.662292] [<c01476ac>] (strlen+0xc/0x20) from [<c00f5e6c>]
>> (sysfs_readdir+0x15c/0x1e0)
>> [ 4776.670501] [<c00f5e6c>] (sysfs_readdir+0x15c/0x1e0) from
>> [<c00b982c>] (vfs_readdir+0x80/0xb4)
>> [ 4776.679229] [<c00b982c>] (vfs_readdir+0x80/0xb4) from [<c00b98c4>]
>> (sys_getdents64+0x64/0xb4)
>> [ 4776.687866] [<c00b98c4>] (sys_getdents64+0x64/0xb4) from
>> [<c002b940>] (ret_fast_syscall+0x0/0x38)
>> [ 4776.696838] Code: c027700c e1a03000 ea000000 e2833001 (e5d32000)
>> [ 4776.703063] ---[ end trace 6a3b0fdf4e9def99 ]---
>> [ 4776.707794] Kernel panic - not syncing: Fatal exception
>
>> Also removing wl1251_spi causes a crash. The reason for this is that a
>> sysfs file with a null string as name is trying to be removed from the
>> notes directory.
>
> Yes, this is because the notes sections describe the text sections.
> When we ignore an empty text section, we'd need to ignore its
> corresponding notes section.
>
> The reason we didn't see this on parisc is because our compiler doesn't
> actually produce any notes sections.
>
>> I found out that reverting this patch solves the problem:
>>
>>   commit 35dead4235e2b67da7275b4122fed37099c2f462
>>   Author: Helge Deller <deller@gmx.de>
>>   Date:   Thu Dec 3 00:29:15 2009 +0100
>>
>>     modules: don't export section names of empty sections via sysfs
>>
>>     On the parisc architecture we face for each and every loaded
>>     kernel module this kernel "badness warning":
>>
>>       sysfs: cannot create duplicate filename
>>     '/module/ac97_bus/sections/.text'
>>       Badness at fs/sysfs/dir.c:487
>>
>>     Reason for that is, that on parisc all kernel modules do have
>>     multiple .text sections due to the usage of the
>>     -ffunction-sections compiler flag which is needed to reach all
>>     jump targets on this platform.
>>
>>     An objdump on such a kernel module gives:
>>     Sections:
>>     Idx Name          Size      VMA       LMA       File off  Algn
>>       0 .note.gnu.build-id 00000024  00000000  00000000  00000034
>>     2**2
>>                       CONTENTS, ALLOC, LOAD, READONLY, DATA
>>       1 .text         00000000  00000000  00000000  00000058  2**0
>>                       CONTENTS, ALLOC, LOAD, READONLY, CODE
>>       2 .text.ac97_bus_match 0000001c  00000000  00000000  00000058
>>     2**2
>>                       CONTENTS, ALLOC, LOAD, READONLY, CODE
>>       3 .text         00000000  00000000  00000000  000000d4  2**0
>>                       CONTENTS, ALLOC, LOAD, READONLY, CODE
>>     ...
>>     Since the .text sections are empty (size of 0 bytes) and won't be
>>     loaded by the kernel module loader anyway, I don't see a reason
>>     why such sections need to be listed under
>>     /sys/module/<module_name>/sections/<section_name> either.
>>
>>     The attached patch does solve this issue by not exporting section
>>     names which are empty.
>>
>>     This fixes bugzilla
>>     http://bugzilla.kernel.org/show_bug.cgi?id=14703
>>
>>     Signed-off-by: Helge Deller <deller@gmx.de>
>>     CC: rusty@rustcorp.com.au
>>     CC: akpm@linux-foundation.org
>>     CC: James.Bottomley@HansenPartnership.com
>>     CC: roland@redhat.com
>>     CC: dave@hiauly1.hia.nrc.ca
>>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>>
>> I was also able to reproduce the problem with vanilla 2.6.32. I'm
>> pretty sure (but haven't tested) that 2.6.32-rc8 does not have this
>> problem.
>>
>> My original mail containing more info:
>>
>> http://www.spinics.net/lists/linux-wireless/msg44863.html
>>
>> Simple bandaid patch below fixes the problem. I know it's not a proper
>> solution, but hopefully makes it easier to understand the problem.
>> Unfortunately my knowledge about ELF is too limited to fix this
>> properly, but I can provide more information as needed. Or even try to
>> fix it myself if someone else holds my hand :)
>>
>> --- a/kernel/module.c
>> +++ b/kernel/module.c
>> @@ -1189,10 +1189,13 @@ static void add_notes_attrs(struct module
>> *mod, unsigned int nsect,
>>         if (!notes_attrs->dir)
>>                 goto out;
>>
>> -       for (i = 0; i < notes; ++i)
>> +       for (i = 0; i < notes; ++i) {
>> +               if (WARN_ON(!notes_attrs->attrs[i].attr.name))
>> +                       continue;
>>                 if (sysfs_create_bin_file(notes_attrs->dir,
>>                                           &notes_attrs->attrs[i]))
>>                         goto out;
>> +       }
>>
>>         mod->notes_attrs = notes_attrs;
>>         return;
>
> A better, and more comprehensive patch would be to try not to count the
> empty text sections when we're building the notes section (and actually
> anywhere else in the file).  This patch actually relies on the fact that
> if sh_size is zero for the text section it should be for the
> corresponding notes section.  If that doesn't work, we'd actually have
> to do the matching in the construction piece.
>
> Can you try it to see if it works for you?  If it doesn't, I'll try
> matching notes to text.  It works fine on parisc, but as we don't have a
> notes section, that's not saying much ...
>
> Thanks,
>
> James
>


This patch looks fine for me, except that I don't think it's necessary
to introduce an inline function for that...

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks!

> ---
>
> diff --git a/kernel/module.c b/kernel/module.c
> index e96b8ed..957f912 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -132,6 +132,11 @@ void __module_put_and_exit(struct module *mod, long code)
>  }
>  EXPORT_SYMBOL(__module_put_and_exit);
>
> +static inline int section_allocated(Elf_Shdr hdr)
> +{
> +       return (hdr.sh_flags & SHF_ALLOC) && hdr.sh_size != 0;
> +}
> +
>  /* Find a module section: 0 means not found. */
>  static unsigned int find_sec(Elf_Ehdr *hdr,
>                             Elf_Shdr *sechdrs,
> @@ -142,7 +147,7 @@ static unsigned int find_sec(Elf_Ehdr *hdr,
>
>        for (i = 1; i < hdr->e_shnum; i++)
>                /* Alloc bit cleared means "ignore it." */
> -               if ((sechdrs[i].sh_flags & SHF_ALLOC)
> +               if (section_allocated(sechdrs[i])
>                    && strcmp(secstrings+sechdrs[i].sh_name, name) == 0)
>                        return i;
>        return 0;
> @@ -1051,8 +1056,7 @@ static void add_sect_attrs(struct module *mod, unsigned int nsect,
>
>        /* Count loaded sections and allocate structures */
>        for (i = 0; i < nsect; i++)
> -               if (sechdrs[i].sh_flags & SHF_ALLOC
> -                   && sechdrs[i].sh_size)
> +               if (section_allocated(sechdrs[i]))
>                        nloaded++;
>        size[0] = ALIGN(sizeof(*sect_attrs)
>                        + nloaded * sizeof(sect_attrs->attrs[0]),
> @@ -1070,9 +1074,7 @@ static void add_sect_attrs(struct module *mod, unsigned int nsect,
>        sattr = &sect_attrs->attrs[0];
>        gattr = &sect_attrs->grp.attrs[0];
>        for (i = 0; i < nsect; i++) {
> -               if (! (sechdrs[i].sh_flags & SHF_ALLOC))
> -                       continue;
> -               if (!sechdrs[i].sh_size)
> +               if (!section_allocated(sechdrs[i]))
>                        continue;
>                sattr->address = sechdrs[i].sh_addr;
>                sattr->name = kstrdup(secstrings + sechdrs[i].sh_name,
> @@ -1156,7 +1158,7 @@ static void add_notes_attrs(struct module *mod, unsigned int nsect,
>        /* Count notes sections and allocate structures.  */
>        notes = 0;
>        for (i = 0; i < nsect; i++)
> -               if ((sechdrs[i].sh_flags & SHF_ALLOC) &&
> +               if (section_allocated(sechdrs[i]) &&
>                    (sechdrs[i].sh_type == SHT_NOTE))
>                        ++notes;
>
> @@ -1172,7 +1174,7 @@ static void add_notes_attrs(struct module *mod, unsigned int nsect,
>        notes_attrs->notes = notes;
>        nattr = &notes_attrs->attrs[0];
>        for (loaded = i = 0; i < nsect; ++i) {
> -               if (!(sechdrs[i].sh_flags & SHF_ALLOC))
> +               if (!section_allocated(sechdrs[i]))
>                        continue;
>                if (sechdrs[i].sh_type == SHT_NOTE) {
>                        nattr->attr.name = mod->sect_attrs->attrs[loaded].name;
> @@ -1720,7 +1722,7 @@ static char elf_type(const Elf_Sym *sym,
>                return '?';
>        if (sechdrs[sym->st_shndx].sh_flags & SHF_EXECINSTR)
>                return 't';
> -       if (sechdrs[sym->st_shndx].sh_flags & SHF_ALLOC
> +       if (section_allocated(sechdrs[sym->st_shndx])
>            && sechdrs[sym->st_shndx].sh_type != SHT_NOBITS) {
>                if (!(sechdrs[sym->st_shndx].sh_flags & SHF_WRITE))
>                        return 'r';
> @@ -1751,7 +1753,7 @@ static bool is_core_symbol(const Elf_Sym *src, const Elf_Shdr *sechdrs,
>                return false;
>
>        sec = sechdrs + src->st_shndx;
> -       if (!(sec->sh_flags & SHF_ALLOC)
> +       if (!section_allocated(*sec)
>  #ifndef CONFIG_KALLSYMS_ALL
>            || !(sec->sh_flags & SHF_EXECINSTR)
>  #endif
> @@ -1913,7 +1915,7 @@ static void kmemleak_load_module(struct module *mod, Elf_Ehdr *hdr,
>        kmemleak_scan_area(mod, sizeof(struct module), GFP_KERNEL);
>
>        for (i = 1; i < hdr->e_shnum; i++) {
> -               if (!(sechdrs[i].sh_flags & SHF_ALLOC))
> +               if (!section_allocated(sechdrs[i]))
>                        continue;
>                if (strncmp(secstrings + sechdrs[i].sh_name, ".data", 5) != 0
>                    && strncmp(secstrings + sechdrs[i].sh_name, ".bss", 4) != 0)
> @@ -2139,7 +2141,7 @@ static noinline struct module *load_module(void __user *umod,
>        for (i = 0; i < hdr->e_shnum; i++) {
>                void *dest;
>
> -               if (!(sechdrs[i].sh_flags & SHF_ALLOC))
> +               if (!section_allocated(sechdrs[i]))
>                        continue;
>
>                if (sechdrs[i].sh_entsize & INIT_OFFSET_MASK)
> @@ -2287,7 +2289,7 @@ static noinline struct module *load_module(void __user *umod,
>                        continue;
>
>                /* Don't bother with non-allocated sections */
> -               if (!(sechdrs[info].sh_flags & SHF_ALLOC))
> +               if (!section_allocated(sechdrs[info]))
>                        continue;
>
>                if (sechdrs[i].sh_type == SHT_REL)
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
