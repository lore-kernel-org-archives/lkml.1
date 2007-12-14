Return-Path: <linux-kernel-owner+w=401wt.eu-S1764580AbXLNQbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764580AbXLNQbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 11:31:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbXLNQbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 11:31:43 -0500
Received: from smtp28.orange.fr ([80.12.242.101]:57635 "EHLO smtp28.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963AbXLNQbm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 11:31:42 -0500
X-Greylist: delayed 171919 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Dec 2007 11:31:42 EST
X-ME-UUID: 20071214163140737.B40387000086@mwinf2822.orange.fr
Message-ID: <4762AFE2.2000003@cosmosbay.com>
Date: Fri, 14 Dec 2007 17:31:30 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.13 (Windows/20070809)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: Adrian Bunk <bunk@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: RFC: remove __read_mostly
References: <20071213222044.GH21616@stusta.de> <p73bq8ugrez.fsf@bingen.suse.de> <20071213224111.GI21616@stusta.de> <200712141716.47742.arnd@arndb.de>
In-Reply-To: <200712141716.47742.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann a écrit :
> On Thursday 13 December 2007, Adrian Bunk wrote:
>   
>> On Thu, Dec 13, 2007 at 11:29:08PM +0100, Andi Kleen wrote:
>>     
>>> Adrian Bunk <bunk@kernel.org> writes:
>>>       
>>>> -rwxrwxr-x 1 bunk bunk 46607243 2007-12-13 19:50 vmlinux.old
>>>> -rwxrwxr-x 1 bunk bunk 46598691 2007-12-13 21:55 vmlinux
>>>>         
>>> File sizes are useless -- check size output.
>>>       
>>     text    data     bss      dec     hex filename
>> 29268488 3697961 5222400 38188849 246b731 vmlinux.old
>> 29268435 3685565 5228784 38192784 246c690 vmlinux
>>     
>
> Just to make sure everyone interprets this correctly:
>
> The file size in the first example suggests a 8552 byte
> (0.02%) size improvement for removing __read_mostly.
>
> The size output shows a -3935 byte (0.01%) size penalty
> instead, much smaller because data that was moved out to
> the .data.read_mostly section from .bss now takes space
> in the binary but won't consume more RAM.
>
> Since 'size' does not take any sections except text, data and
> bss into account, its output is more often than not also
> misleading, but at least it shows that the footprint is likely
> to get larger without __read_mostly rather than smaller.
>
>   
Your analysis is fine, except the last point. Just check "size -A 
vmlinux" and you'll see
that "size vmlinux" take into account not only "text, data and bss"

# size vmlinux
   text    data     bss     dec     hex filename
4835243  450722  610304 5896269  59f84d vmlinux
# size -A vmlinux
vmlinux  :
section                      size         addr
.text.head                    885   3222274048
.text                     3359764   3222278144
__ex_table                   3904   3225637920
.notes                         36   3225641824
__bug_table                 21120   3225641864
.rodata                   1130680   3225665536
.pci_fixup                   2192   3226796216
__ksymtab                   23104   3226798408
__ksymtab_gpl                7224   3226821512
__ksymtab_unused_gpl           16   3226828736
__ksymtab_gpl_future           24   3226828752
__ksymtab_strings           72470   3226828776
__param                      4020   3226901248
.data                      309056   3226906624
.data_nosave                 4096   3227217920
.data.page_aligned           2048   3227222016
.data.cacheline_aligned     46720   3227224064
.data.read_mostly           11388   3227270784
.data.init_task              8192   3227287552
.smp_locks                  19128   3227295744
.init.text                 137115   3227316224
.init.data                  40290   3227453344
.init.setup                  1656   3227493648
.initcall.init               1124   3227495304
.con_initcall.init              8   3227496428
.altinstructions            38771   3227496436
.altinstr_replacement        9908   3227535207
.exit.text                   4750   3227545116
.init.ramfs                   132   3227553792
.data.percpu                26144   3227557888
.bss                       610304   3227586560
.comment                    19746            0
Total                     5916015




