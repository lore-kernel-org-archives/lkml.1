Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbZA2Mcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbZA2Mcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 07:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbZA2Mca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 07:32:30 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:12396 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbZA2Mc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 07:32:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=XSDZhE2ohKatzuiJ0eqJWBCooiJbj8jqOXPssRU/2xGqfB/p+4EAaDpUoxd7Lhm4BX
         DVUD+1qaRXAj+pHgnCA+FPpDOCz5LP4gY01AnDMS+pOW22n9qT0Im71aRRisvQBwonWn
         JW1A6/NLM6nhAAudOW2FLAkrXRSYove0i7c00=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <4981102C.2000400@linux.vnet.ibm.com>
References: <20090121185021.GA8852@elte.hu>
	 <4981102C.2000400@linux.vnet.ibm.com>
Date: Thu, 29 Jan 2009 13:32:26 +0100
Message-ID: <7c86c4470901290432h77d479c9k160a7b793b2812bb@mail.gmail.com>
Subject: Re: [announce] Performance Counters for Linux, v6
From: stephane eranian <eranian@googlemail.com>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>,
       "perfmon2-devel@lists.sourceforge.net" 
	<perfmon2-devel@lists.sourceforge.net>,
       Papi <ptools-perfapi@cs.utk.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corey,

On Thu, Jan 29, 2009 at 3:10 AM, Corey Ashford
<cjashfor@linux.vnet.ibm.com> wrote:
> Ingo Molnar wrote:
>>
>> We are pleased to announce version 6 of our performance counters subsystem
>> implementation. The shortlog, diffstat and the combo patch can be found
>> below. The combo patch against latest -git (2.6.29-rc2) can be also found
>> at:
>>
>>
>> http://people.redhat.com/mingo/perfcounters/perfcounters-v6-v2.6.29-rc2.patch
>>
>> It's also available in tip/master at:
>>
>>   http://people.redhat.com/mingo/tip.git/README
>>
>> There are many changes in the v6 release:
>>
>>  - PowerPC performance counters support from Paul Mackerras, for POWER6
>>   and for the PPC970 family.
>>
>>  - ioctl API to disable/enable individual counters and groups without
>>   closing their fd. This can be useful for libraries, ad-hoc
>> instrumentation and PAPI support.
>>
>>  - 'pinned' and 'exclusive' counter attributes - for those
>>   applications that want to influence counter scheduling explicitly.
>>
>>  - The 'perfstat' utility (ex 'timec') has been updated:
>>
>>      http://people.redhat.com/mingo/perfcounters/perfstat.c
>>
>>  - 'kerneltop' (easy-to-use text mode NMI profiler) has been updated:
>>        http://people.redhat.com/mingo/perfcounters/kerneltop.c
>>
>>  - Merged to latest mainline
>>
>>  - Various fixes and other updates
>>
>>        Ingo
>
> I'm not sure if this is the right place to propose such a thing, but I think
> it would be very valuable to have a standardized user-side library to
> accompany this addition to the kernel.
>
> In particular, as a starting place for the discussion, I'd like to see
> functions in it that are very similar to a subset of what is currently in
> libpfm.  Specifically, I'd like to see the following functions (with the
> names changed to pcl_* perhaps):
>
> extern pfm_err_t pfm_find_event(const char *str, unsigned int *idx);
> extern pfm_err_t pfm_find_event_bycode(int code, unsigned int *idx);
> extern pfm_err_t pfm_find_event_bycode_next(int code, unsigned int start,
>                                            unsigned int *next);
> extern pfm_err_t pfm_find_event_mask(unsigned int event_idx, const char
> *str,
>                                     unsigned int *mask_idx);
> extern pfm_err_t pfm_find_full_event(const char *str, pfmlib_event_t *e);
>
> extern pfm_err_t pfm_get_max_event_name_len(size_t *len);
>
> extern pfm_err_t pfm_get_num_events(unsigned int *count);
> extern pfm_err_t pfm_get_num_event_masks(unsigned int event_idx,
>                                         unsigned int *count);
> extern pfm_err_t pfm_get_event_name(unsigned int idx, char *name,
>                                    size_t maxlen);
> extern pfm_err_t pfm_get_full_event_name(pfmlib_event_t *e, char *name,
>                                         size_t maxlen);
> extern pfm_err_t pfm_get_event_code(unsigned int idx, int *code);
> extern pfm_err_t pfm_get_event_mask_code(unsigned int idx,
>                                         unsigned int mask_idx,
>                                         unsigned int *code);
> extern pfm_err_t pfm_get_event_description(unsigned int idx, char **str);
> extern pfm_err_t pfm_get_event_code_counter(unsigned int idx, unsigned int
> cnt,
>                                            int *code);
> extern pfm_err_t pfm_get_event_mask_name(unsigned int event_idx,
>                                         unsigned int mask_idx,
>                                         char *name, size_t maxlen);
> extern pfm_err_t pfm_get_event_mask_description(unsigned int event_idx,
>                                                unsigned int mask_idx,
>                                                char **desc);
>
>
> Now, since it's not clear right now how unit masks are going to be handled
> in your proposal, I'm not sure the that *_event_mask_* functions are
> applicable, but I think something that fills that function will be needed.
>
> Architectures that have need for additional functionality should be free to
> add arch-specific functions.
>
> Full descriptions of these functions can be found in the man pages of the
> libpfm documentation.
>
> Any thoughts on this?  Do you already have a us
er library structure in mind?
>
Yes, I did give some thoughts to all of this. In fact, I have been
playing a bit with
libpfm and the LPC proposal.

I think, given that LPC is dealing with event -> counter assignment in
the kernel, libpfm
does not have to do it. All it needs to do is event:attributes ->
value, and that value is
then passed to the kernel in raw mode.

Event attributes includes on x86, for instance, the edge, invert,
counter-mask, plm, field.
I think we could do something more generic than what is currently
there. That would not
require PMU specific data structures for attributes. Just pass
everything into a string.

To that extent, I have been experimenting with something along those lines:

    int pfm_get_event_encoding(char *event_str, uint64_t **values, int *count);

events are encoded as follows:

   event_name:[unit_mask1:unit_mask2:...:unit_maskn][::A1=V1:A2=V2:..:An=Vn]

Attribute names and values depend on each PMU model. Attributes names
are strings.
Values can have any type.

For X86, most attributes would be identical, same thing on Itanium
because they are
architected.

Some PMU models may need more than one 64-bit value to configure one
event, That is
is why there is vector and a count. Libpfm should not be concerned
with how those values
are encoded and passed to the kernel. It should be concerned with the
event -> value
as described in the PMU documentation.

Given that LPC manages events independently of each other, libpfm does
not reallly need
to process multiple events at a time to get a global view of what is
being measured.

Here is an example:

$ self inst_retired:any_p::i=1:c=1:u=1:k=1
[0x1d300c0 event_sel=0xc0 umask=0x0 os=1 usr=1 en=1 int=1 inv=1 edge=0
cnt_mask=1] INST_RETIRED
