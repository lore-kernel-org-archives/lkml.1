Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386AbYGCSva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbYGCSva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 14:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbYGCSvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 14:51:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:31922 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbYGCSvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 14:51:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PO9GQ5Ku7QP8n0jQpsmLFc3EyZEK49TuEeTIv651FJXd4UN7F8qQ2OkVupHOIL0uxa
         PIYGw58eqiTmaSyeWLQ0Q4gWQ5w5l4d3v2OhKgLoRObbxD99HGnti3V+mplunaKR7vxa
         WyooB1G85CJHUgwk81BjwJzkJ5wsgML+UreWc=
Message-ID: <86802c440807031151o577d001g3e72bae3aa88df25@mail.gmail.com>
Date: Thu, 3 Jul 2008 11:51:18 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [Xen-devel] Re: [PATCH 00 of 36] x86/paravirt: groundwork for 64-bit Xen support
Cc: "Ingo Molnar" <mingo@elte.hu>, "Nick Piggin" <npiggin@suse.de>,
       "Mark McLoughlin" <markmc@redhat.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       "Eduardo Habkost" <ehabkost@redhat.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Stephen Tweedie" <sct@redhat.com>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <486D1D40.9050309@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <486539A3.3030102@goop.org> <20080701085204.GA23289@elte.hu>
	 <20080701092152.GA18918@elte.hu> <486A57C8.3010008@goop.org>
	 <20080701203123.GG4896@elte.hu> <20080703091053.GA1883@elte.hu>
	 <86802c440807031120o6e87459em8c4f239eb1a2507c@mail.gmail.com>
	 <486D19B1.1080402@goop.org>
	 <86802c440807031130keada2fbva256f2efe3c4801@mail.gmail.com>
	 <486D1D40.9050309@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2008 at 11:41 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Yinghai Lu wrote:
>>
>> On Thu, Jul 3, 2008 at 11:25 AM, Jeremy Fitzhardinge <jeremy@goop.org>
>> wrote:
>>
>>>
>>> Yinghai Lu wrote:
>>>
>>>>
>>>> On Thu, Jul 3, 2008 at 2:10 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>>>
>>>>
>>>>>
>>>>> * Ingo Molnar <mingo@elte.hu> wrote:
>>>>>
>>>>>
>>>>>
>>>>>>
>>>>>> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>>>
>>>>>>> Ingo Molnar wrote:
>>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>> Excluding the x86/xen-64bit topic solves the problem.
>>>>>>>>
>>>>>>>> It triggered on two 64-bit machines so it seems readily reproducible
>>>>>>>> with that config.
>>>>>>>>
>>>>>>>> i've pushed the failing tree out to
>>>>>>>> tip/tmp.xen-64bit.Tue_Jul__1_10_55
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>
>>>>>>> The patch to fix this is on tip/x86/unify-setup: "x86: setup_arch()
>>>>>>> &&
>>>>>>> early_ioremap_init()".  Logically that patch should probably be in
>>>>>>> the
>>>>>>> xen64 branch, since it's only meaningful with the early_ioremap
>>>>>>> unification.
>>>>>>>
>>>>>>>
>>>>>>
>>>>>> ah, indeed - it was missing from tip/master due to:
>>>>>>
>>>>>> | commit ac998c259605741efcfbd215533b379970ba1d9f
>>>>>> | Author: Ingo Molnar <mingo@elte.hu>
>>>>>> | Date:   Mon Jun 30 12:01:31 2008 +0200
>>>>>> |
>>>>>> |    Revert "x86: setup_arch() && early_ioremap_init()"
>>>>>> |
>>>>>> |    This reverts commit 181b3601a1a7d2ac3ace6b23cb3204450a4f9a27.
>>>>>>
>>>>>> because that change needed the other changes from xen-64bit.
>>>>>>
>>>>>> will retry tomorrow.
>>>>>>
>>>>>>
>>>>>
>>>>> ok, i've re-added x86/xen-64bit and it's looking good in testing so
>>>>> far.
>>>>>
>>>>>
>>>>>
>>>>
>>>> got
>>>>  [ffffe20000000000-ffffe27fffffffff] PGD ->ffff88000128a000 on node 0
>>>>  [ffffe20000000000-ffffe2003fffffff] PUD ->ffff88000128b000 on node 0
>>>>  [ffffe20000000000-ffffe200003fffff] PMD ->
>>>> [ffff880001400000-ffff8800017fffff] on node 0
>>>>  [ffffe20000200000-ffffe200005fffff] PMD ->
>>>> [ffff880001600000-ffff8800019fffff] on node 0
>>>>  [ffffe20000400000-ffffe200007fffff] PMD ->
>>>> [ffff880001800000-ffff880001bfffff] on node 0
>>>>  [ffffe20000600000-ffffe200009fffff] PMD ->
>>>> [ffff880001a00000-ffff880001dfffff] on node 0
>>>>  [ffffe20000800000-ffffe20000bfffff] PMD ->
>>>> [ffff880001c00000-ffff880001ffffff] on node 0
>>>>  [ffffe20000a00000-ffffe20000dfffff] PMD ->
>>>> [ffff880001e00000-ffff8800021fffff] on node 0
>>>>  [ffffe20000c00000-ffffe20000ffffff] PMD ->
>>>> [ffff880002000000-ffff8800023fffff] on node 0
>>>>  [ffffe20000e00000-ffffe200011fffff] PMD ->
>>>> [ffff880002200000-ffff8800025fffff] on node 0
>>>>  [ffffe20001000000-ffffe200013fffff] PMD ->
>>>> [ffff880002400000-ffff8800027fffff] on node 0
>>>>  [ffffe20001200000-ffffe200015fffff] PMD ->
>>>> [ffff880002600000-ffff8800029fffff] on node 0
>>>>  [ffffe20001400000-ffffe200017fffff] PMD ->
>>>> [ffff880002800000-ffff880002bfffff] on node 0
>>>>  [ffffe20001600000-ffffe200019fffff] PMD ->
>>>> [ffff880002a00000-ffff880002dfffff] on node 0
>>>>  [ffffe20001800000-ffffe20001bfffff] PMD ->
>>>> [ffff880002c00000-ffff880002ffffff] on node 0
>>>>  [ffffe20001a00000-ffffe20001dfffff] PMD ->
>>>> [ffff880002e00000-ffff8800031fffff] on node 0
>>>>  [ffffe20001c00000-ffffe20001ffffff] PMD ->
>>>> [ffff880003000000-ffff8800033fffff] on node 0
>>>>  [ffffe20001e00000-ffffe200021fffff] PMD ->
>>>> [ffff880003200000-ffff8800035fffff] on node 0
>>>>  [ffffe20002000000-ffffe200023fffff] PMD ->
>>>> [ffff880003400000-ffff8800037fffff] on node 0
>>>>  [ffffe20002200000-ffffe200025fffff] PMD ->
>>>> [ffff880003600000-ffff8800039fffff] on node 0
>>>>  [ffffe20002400000-ffffe200027fffff] PMD ->
>>>> [ffff880003800000-ffff880003bfffff] on node 0
>>>>  [ffffe20002600000-ffffe200029fffff] PMD ->
>>>> [ffff880003a00000-ffff880003dfffff] on node 0
>>>>  [ffffe20002800000-ffffe20002bfffff] PMD ->
>>>> [ffff880003c00000-ffff880003ffffff] on node 0
>>>>  [ffffe20002a00000-ffffe20002dfffff] PMD ->
>>>> [ffff880003e00000-ffff8800041fffff] on node 0
>>>>  [ffffe20002c00000-ffffe20002ffffff] PMD ->
>>>> [ffff880004000000-ffff8800043fffff] on node 0
>>>>  [ffffe20002e00000-ffffe200039fffff] PMD ->
>>>> [ffff880004200000-ffff8800045fffff] on node 0
>>>>  [ffffe20003800000-ffffe20003bfffff] PMD ->
>>>> [ffff880004400000-ffff8800047fffff] on node 0
>>>>  [ffffe20003a00000-ffffe20003dfffff] PMD ->
>>>> [ffff880004600000-ffff8800049fffff] on node 0
>>>>  [ffffe20003c00000-ffffe20003ffffff] PMD ->
>>>> [ffff880004800000-ffff880004bfffff] on node 0
>>>>  [ffffe20003e00000-ffffe200041fffff] PMD ->
>>>> [ffff880004a00000-ffff880004dfffff] on node 0
>>>>  [ffffe20004000000-ffffe200043fffff] PMD ->
>>>> [ffff880004c00000-ffff880004ffffff] on node 0
>>>>  [ffffe20004200000-ffffe200045fffff] PMD ->
>>>> [ffff880004e00000-ffff8800051fffff] on node 0
>>>>  [ffffe20004400000-ffffe200047fffff] PMD ->
>>>> [ffff880005000000-ffff8800053fffff] on node 0
>>>>  [ffffe20004600000-ffffe200049fffff] PMD ->
>>>> [ffff880005200000-ffff8800055fffff] on node 0
>>>>  [ffffe20004800000-ffffe20004bfffff] PMD ->
>>>> [ffff880005400000-ffff8800057fffff] on node 0
>>>>  [ffffe20004a00000-ffffe20004dfffff] PMD ->
>>>> [ffff880005600000-ffff8800059fffff] on node 0
>>>>  [ffffe20004c00000-ffffe20004ffffff] PMD ->
>>>> [ffff880005800000-ffff880005bfffff] on node 0
>>>>  [ffffe20004e00000-ffffe200051fffff] PMD ->
>>>> [ffff880005a00000-ffff880005dfffff] on node 0
>>>>  [ffffe20005000000-ffffe200053fffff] PMD ->
>>>> [ffff880005c00000-ffff880005ffffff] on node 0
>>>>  [ffffe20005200000-ffffe200055fffff] PMD ->
>>>> [ffff880005e00000-ffff8800061fffff] on node 0
>>>>  [ffffe20005400000-ffffe200057fffff] PMD ->
>>>> [ffff880006000000-ffff8800063fffff] on node 0
>>>>  [ffffe20005600000-ffffe200059fffff] PMD ->
>>>> [ffff880006200000-ffff8800065fffff] on node 0
>>>>  [ffffe20005800000-ffffe20005bfffff] PMD ->
>>>> [ffff880006400000-ffff8800067fffff] on node 0
>>>>  [ffffe20005a00000-ffffe20005dfffff] PMD ->
>>>> [ffff880006600000-ffff8800069fffff] on node 0
>>>>  [ffffe20005c00000-ffffe20005ffffff] PMD ->
>>>> [ffff880006800000-ffff880006bfffff] on node 0
>>>>  [ffffe20005e00000-ffffe200061fffff] PMD ->
>>>> [ffff880006a00000-ffff880006dfffff] on node 0
>>>>  [ffffe20006000000-ffffe200063fffff] PMD ->
>>>> [ffff880006c00000-ffff880006ffffff] on node 0
>>>>  [ffffe20006200000-ffffe200065fffff] PMD ->
>>>> [ffff880006e00000-ffff8800071fffff] on node 0
>>>>  [ffffe20006400000-ffffe200067fffff] PMD ->
>>>> [ffff880007000000-ffff8800073fffff] on node 0
>>>>  [ffffe20006600000-ffffe200069fffff] PMD ->
>>>> [ffff880007200000-ffff8800075fffff] on node 0
>>>>  [ffffe20006800000-ffffe20006bfffff] PMD ->
>>>> [ffff880007400000-ffff8800077fffff] on node 0
>>>>  [ffffe20006a00000-ffffe20006dfffff] PMD ->
>>>> [ffff880007600000-ffff8800079fffff] on node 0
>>>>  [ffffe20006c00000-ffffe20006ffffff] PMD ->
>>>> [ffff880007800000-ffff880007bfffff] on node 0
>>>>  [ffffe20006e00000-ffffe200071fffff] PMD ->
>>>> [ffff880007a00000-ffff880007dfffff] on node 0
>>>>  [ffffe20007000000-ffffe200073fffff] PMD ->
>>>> [ffff880007c00000-ffff880007ffffff] on node 0
>>>>  [ffffe20007200000-ffffe200075fffff] PMD ->
>>>> [ffff880007e00000-ffff8800081fffff] on node 0
>>>>  [ffffe20007400000-ffffe200077fffff] PMD ->
>>>> [ffff880008000000-ffff8800083fffff] on node 0
>>>>  [ffffe20007600000-ffffe200079fffff] PMD ->
>>>> [ffff880008200000-ffff8800085fffff] on node 0
>>>> [ffffe200078c0000-ffffe200079fffff] potential offnode page_structs
>>>>  [ffffe20007800000-ffffe20007bfffff] PMD ->
>>>> [ffff880008400000-ffff8802283fffff] on node 0
>>>>  [ffffe20007a00000-ffffe20007dfffff] PMD ->
>>>> [ffff880228200000-ffff8802285fffff] on node 1
>>>>  [ffffe20007c00000-ffffe20007ffffff] PMD ->
>>>> [ffff880228400000-ffff8802287fffff] on node 1
>>>>  [ffffe20007e00000-ffffe200081fffff] PMD ->
>>>> [ffff880228600000-ffff8802289fffff] on node 1
>>>>  [ffffe20008000000-ffffe200083fffff] PMD ->
>>>> [ffff880228800000-ffff880228bfffff] on node 1
>>>>  [ffffe20008200000-ffffe200085fffff] PMD ->
>>>> [ffff880228a00000-ffff880228dfffff] on node 1
>>>>  [ffffe20008400000-ffffe200087fffff] PMD ->
>>>> [ffff880228c00000-ffff880228ffffff] on node 1
>>>>  [ffffe20008600000-ffffe200089fffff] PMD ->
>>>> [ffff880228e00000-ffff8802291fffff] on node 1
>>>>  [ffffe20008800000-ffffe20008bfffff] PMD ->
>>>> [ffff880229000000-ffff8802293fffff] on node 1
>>>>  [ffffe20008a00000-ffffe20008dfffff] PMD ->
>>>> [ffff880229200000-ffff8802295fffff] on node 1
>>>>  [ffffe20008c00000-ffffe20008ffffff] PMD ->
>>>> [ffff880229400000-ffff8802297fffff] on node 1
>>>>  [ffffe20008e00000-ffffe200091fffff] PMD ->
>>>> [ffff880229600000-ffff8802299fffff] on node 1
>>>>  [ffffe20009000000-ffffe200093fffff] PMD ->
>>>> [ffff880229800000-ffff880229bfffff] on node 1
>>>>  [ffffe20009200000-ffffe200095fffff] PMD ->
>>>> [ffff880229a00000-ffff880229dfffff] on node 1
>>>>  [ffffe20009400000-ffffe200097fffff] PMD ->
>>>> [ffff880229c00000-ffff880229ffffff] on node 1
>>>>  [ffffe20009600000-ffffe200099fffff] PMD ->
>>>> [ffff880229e00000-ffff88022a1fffff] on node 1
>>>>  [ffffe20009800000-ffffe20009bfffff] PMD ->
>>>> [ffff88022a000000-ffff88022a3fffff] on node 1
>>>>  [ffffe20009a00000-ffffe20009dfffff] PMD ->
>>>> [ffff88022a200000-ffff88022a5fffff] on node 1
>>>>  [ffffe20009c00000-ffffe20009ffffff] PMD ->
>>>> [ffff88022a400000-ffff88022a7fffff] on node 1
>>>>  [ffffe20009e00000-ffffe2000a1fffff] PMD ->
>>>> [ffff88022a600000-ffff88022a9fffff] on node 1
>>>>  [ffffe2000a000000-ffffe2000a3fffff] PMD ->
>>>> [ffff88022a800000-ffff88022abfffff] on node 1
>>>>  [ffffe2000a200000-ffffe2000a5fffff] PMD ->
>>>> [ffff88022aa00000-ffff88022adfffff] on node 1
>>>>  [ffffe2000a400000-ffffe2000a7fffff] PMD ->
>>>> [ffff88022ac00000-ffff88022affffff] on node 1
>>>>  [ffffe2000a600000-ffffe2000a9fffff] PMD ->
>>>> [ffff88022ae00000-ffff88022b1fffff] on node 1
>>>>  [ffffe2000a800000-ffffe2000abfffff] PMD ->
>>>> [ffff88022b000000-ffff88022b3fffff] on node 1
>>>>  [ffffe2000aa00000-ffffe2000adfffff] PMD ->
>>>> [ffff88022b200000-ffff88022b5fffff] on node 1
>>>>  [ffffe2000ac00000-ffffe2000affffff] PMD ->
>>>> [ffff88022b400000-ffff88022b7fffff] on node 1
>>>>  [ffffe2000ae00000-ffffe2000b1fffff] PMD ->
>>>> [ffff88022b600000-ffff88022b9fffff] on node 1
>>>>  [ffffe2000b000000-ffffe2000b3fffff] PMD ->
>>>> [ffff88022b800000-ffff88022bbfffff] on node 1
>>>>  [ffffe2000b200000-ffffe2000b5fffff] PMD ->
>>>> [ffff88022ba00000-ffff88022bdfffff] on node 1
>>>>  [ffffe2000b400000-ffffe2000b7fffff] PMD ->
>>>> [ffff88022bc00000-ffff88022bffffff] on node 1
>>>>  [ffffe2000b600000-ffffe2000b9fffff] PMD ->
>>>> [ffff88022be00000-ffff88022c1fffff] on node 1
>>>>  [ffffe2000b800000-ffffe2000bbfffff] PMD ->
>>>> [ffff88022c000000-ffff88022c3fffff] on node 1
>>>>  [ffffe2000ba00000-ffffe2000bdfffff] PMD ->
>>>> [ffff88022c200000-ffff88022c5fffff] on node 1
>>>>  [ffffe2000bc00000-ffffe2000bffffff] PMD ->
>>>> [ffff88022c400000-ffff88022c7fffff] on node 1
>>>>  [ffffe2000be00000-ffffe2000c1fffff] PMD ->
>>>> [ffff88022c600000-ffff88022c9fffff] on node 1
>>>>  [ffffe2000c000000-ffffe2000c3fffff] PMD ->
>>>> [ffff88022c800000-ffff88022cbfffff] on node 1
>>>>  [ffffe2000c200000-ffffe2000c5fffff] PMD ->
>>>> [ffff88022ca00000-ffff88022cdfffff] on node 1
>>>>  [ffffe2000c400000-ffffe2000c7fffff] PMD ->
>>>> [ffff88022cc00000-ffff88022cffffff] on node 1
>>>>  [ffffe2000c600000-ffffe2000c9fffff] PMD ->
>>>> [ffff88022ce00000-ffff88022d1fffff] on node 1
>>>>  [ffffe2000c800000-ffffe2000cbfffff] PMD ->
>>>> [ffff88022d000000-ffff88022d3fffff] on node 1
>>>>  [ffffe2000ca00000-ffffe2000cdfffff] PMD ->
>>>> [ffff88022d200000-ffff88022d5fffff] on node 1
>>>>  [ffffe2000cc00000-ffffe2000cffffff] PMD ->
>>>> [ffff88022d400000-ffff88022d7fffff] on node 1
>>>>  [ffffe2000ce00000-ffffe2000d1fffff] PMD ->
>>>> [ffff88022d600000-ffff88022d9fffff] on node 1
>>>>  [ffffe2000d000000-ffffe2000d3fffff] PMD ->
>>>> [ffff88022d800000-ffff88022dbfffff] on node 1
>>>>  [ffffe2000d200000-ffffe2000d5fffff] PMD ->
>>>> [ffff88022da00000-ffff88022ddfffff] on node 1
>>>>  [ffffe2000d400000-ffffe2000d7fffff] PMD ->
>>>> [ffff88022dc00000-ffff88022dffffff] on node 1
>>>>  [ffffe2000d600000-ffffe2000d9fffff] PMD ->
>>>> [ffff88022de00000-ffff88022e1fffff] on node 1
>>>>  [ffffe2000d800000-ffffe2000dbfffff] PMD ->
>>>> [ffff88022e000000-ffff88022e3fffff] on node 1
>>>>  [ffffe2000da00000-ffffe2000ddfffff] PMD ->
>>>> [ffff88022e200000-ffff88022e5fffff] on node 1
>>>>  [ffffe2000dc00000-ffffe2000dffffff] PMD ->
>>>> [ffff88022e400000-ffff88022e7fffff] on node 1
>>>>  [ffffe2000de00000-ffffe2000e1fffff] PMD ->
>>>> [ffff88022e600000-ffff88022e9fffff] on node 1
>>>>  [ffffe2000e000000-ffffe2000e3fffff] PMD ->
>>>> [ffff88022e800000-ffff88022ebfffff] on node 1
>>>>  [ffffe2000e200000-ffffe2000e5fffff] PMD ->
>>>> [ffff88022ea00000-ffff88022edfffff] on node 1
>>>>  [ffffe2000e400000-ffffe2000e7fffff] PMD ->
>>>> [ffff88022ec00000-ffff88022effffff] on node 1
>>>>  [ffffe2000e600000-ffffe2000e9fffff] PMD ->
>>>> [ffff88022ee00000-ffff88022f1fffff] on node 1
>>>>  [ffffe2000e800000-ffffe2000e9fffff] PMD ->
>>>> [ffff88022f000000-ffff88022f1fffff] on node 1
>>>>
>>>> should have
>>>>
>>>>  [ffffe20000000000-ffffe27fffffffff] PGD ->ffff8100011ce000 on node 0
>>>>  [ffffe20000000000-ffffe2003fffffff] PUD ->ffff8100011cf000 on node 0
>>>> [ffffe200078c0000-ffffe200079fffff] potential offnode page_structs
>>>>  [ffffe20000000000-ffffe200079fffff] PMD ->
>>>> [ffff810001200000-ffff8100083fffff] on node 0
>>>>  [ffffe20007a00000-ffffe2000e9fffff] PMD ->
>>>> [ffff810228200000-ffff81022f1fffff] on node 1
>>>>
>>>
>>> I haven't seen those messages before.  Can you explain what they mean?
>>>
>>
>> that is for SPARSEMEM virtual memmap...
>>
>> CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
>> CONFIG_SPARSEMEM_VMEMMAP=y
>>
>
> I modified the vmemmap code so it would create 4k mappings if PSE isn't
> supported.  Did I get it wrong?  It should have no effect when PSE is
> available (which is any time you're not running under Xen).
>

it could be address continuous checkup for printout in
vmemmap_populated has some problem...

YH
