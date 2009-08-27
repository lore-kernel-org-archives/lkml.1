Return-Path: <linux-kernel-owner+w=401wt.eu-S1750868AbZH0Q6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750868AbZH0Q6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 12:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbZH0Q6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 12:58:44 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:21580 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbZH0Q6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 12:58:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=MdhQPCXsteZPza04IIjUXS7ABNT+TlGj5/lmEH5GeG043/aIQIWsnLCmY0vTejEZS5
         jUPSHocqo9LcXjKRQNGUJUxnNqOiB7RH/kNU1m1+he3h28rTsECRzKncZAvp/4HRYrxa
         gJ7TgmYW4htmIe6h+6NiphSjCl6Kl4bvm4O60=
Message-ID: <4A96BB40.1070306@gmail.com>
Date: Thu, 27 Aug 2009 12:58:40 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: FTRACE: regression in 31-rc7
References: <4A96B55C.10001@gmail.com> <20090827164007.GA30679@elte.hu>
In-Reply-To: <20090827164007.GA30679@elte.hu>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5B51D15FFF30A06711A74FAB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5B51D15FFF30A06711A74FAB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Ingo Molnar wrote:
> * Gregory Haskins <gregory.haskins@gmail.com> wrote:
>=20
>> Hi Steve,
>>
>> I just moved from -rc6 to -rc7, and I noticed that the=20
>> function-graph tracer suddenly stopped working properly: I do not=20
>> see any output from seeming most things except a handful of=20
>> interrupt related events.  I currently believe it may be an issue=20
>> with tracing modules.
>>
>> I haven't had a chance to bisect yet, but I did confirm that=20
>> reverting the -rc7 merge restores the previous tracer behavior. =20
>> Any help/pointers appreciated.
>=20
> Works fine here (using -rc7 based -tip):
>=20
>  11)               |  sys_munmap() {
>  11)               |    profile_munmap() {
>  11)               |      blocking_notifier_call_chain() {
>  11)   0.170 us    |        __blocking_notifier_call_chain();
>  11)   0.480 us    |      }
>  11)   0.799 us    |    }
>  11)               |    down_write() {
>  11)   0.146 us    |      _cond_resched();
>  11)   0.146 us    |      _spin_lock_irq();
>  11)   0.754 us    |    }
>  11)               |    do_munmap() {
>  11)   0.144 us    |      test_ti_thread_flag();
>  11)   0.144 us    |      test_ti_thread_flag();
>  11)   0.164 us    |      find_vma();
>  11)   0.156 us    |      arch_unmap_area_topdown();
>  11)               |      unmap_region() {
>  11)               |        lru_add_drain() {
>  11)               |          ____pagevec_lru_add() {
>  11)   0.153 us    |            _spin_lock_irq();
>  11)   0.145 us    |            __inc_zone_state();
>  11)               |            __inc_zone_state() {
>  11)   0.144 us    |            __inc_zone_state();
>  11)   0.146 us    |            __inc_zone_state();
>  11)   0.145 us    |            __inc_zone_state();
>  11)   0.223 us    |            release_pages();
>  11)   2.463 us    |          }
>  11)   2.795 us    |        }
>  11)               |        unmap_vmas() {
>  11)               |          unmap_page_range() {
>  11)   0.144 us    |            pgd_none_or_clear_bad();
>  11)   0.145 us    |            pud_none_or_clear_bad();
>  11)   0.154 us    |            pmd_none_or_clear_bad();
>  11)               |            zap_pte_range() {
>  11)   0.145 us    |              _spin_lock();
>  11)   0.168 us    |              vm_normal_page();
>  11)   0.143 us    |              mark_page_accessed();
>  11)               |              page_remove_rmap() {
>  11)               |                __dec_zone_page_state() {
>  11)   0.150 us    |                  __dec_zone_state();
>  11)   0.441 us    |                }
>  11)   0.748 us    |              }
>  11)   0.149 us    |              vm_normal_page();
>  11)   0.146 us    |              mark_page_accessed();
>  11)               |              page_remove_rmap() {
>  11)               |                __dec_zone_page_state() {
>  11)   0.148 us    |                  __dec_zone_state();
>  11)   0.439 us    |                }
>  11)   0.748 us    |              }
>  11)   0.144 us    |              vm_normal_page();
>  11)   0.148 us    |              mark_page_accessed();
>  11)               |              page_remove_rmap() {
>  11)               |                __dec_zone_page_state() {
>  11)   0.148 us    |                  __dec_zone_state();
>  11)   0.438 us    |                }
>  11)   0.731 us    |              }
>  11)   0.144 us    |              vm_normal_page();
>  11)   0.146 us    |              mark_page_accessed();
>  11)               |              page_remove_rmap() {
>  11)               |                __dec_zone_page_state() {
>  11)   0.146 us    |                  __dec_zone_state();
>  11)   0.437 us    |                }
>  11)   0.733 us    |              }
>  11)   0.143 us    |              vm_normal_page();
>  11)   0.148 us    |              mark_page_accessed();
>  11)               |              page_remove_rmap() {
>  11)               |                __dec_zone_page_state() {
>  11)   0.147 us    |                  __dec_zone_state();
>  11)   0.438 us    |                }
>  11)   0.731 us    |              }
>  11)   0.144 us    |              vm_normal_page();
>  11)   0.146 us    |              mark_page_accessed();
>  11)               |              page_remove_rmap() {
>  11)               |                __dec_zone_page_state() {
>  11)   0.146 us    |                  __dec_zone_state();
>  11)   0.436 us    |                }
>  11)   0.732 us    |              }
>  11)   0.143 us    |              vm_normal_page();
>  11)   0.146 us    |              mark_page_accessed();
>  11)               |              page_remove_rmap() {
>  11)               |                __dec_zone_page_state() {
>  11)   0.147 us    |                  __dec_zone_state();
>  11)   0.435 us    |                }
>  11)   0.751 us    |              }
>  11)   0.142 us    |              vm_normal_page();
>  11)   0.146 us    |              mark_page_accessed();
>  11)               |              page_remove_rmap() {
>  11)               |                __dec_zone_page_state() {
>  11)   0.146 us    |                  __dec_zone_state();
>  11)   0.438 us    |                }
>  11)   0.733 us    |              }
>  11)   0.143 us    |              vm_normal_page();
>  11)   0.145 us    |              mark_page_accessed();
>  11)               |              page_remove_rmap() {
>  11)               |                __dec_zone_page_state() {
>  11)   0.145 us    |                  __dec_zone_state();
>  11)   0.434 us    |                }
>  11)   0.731 us    |              }
>  11) + 14.220 us   |            }
>  11) + 15.442 us   |          }
>  11) + 15.750 us   |        }
>  11)               |        free_pgtables() {
>=20
> so it would be nice if you sent a config and a precise description=20
> of what you did to see the weirdness - in case others have trouble=20
> reproducing it as well.

Yeah, sorry.  I should have provided more detail.  Usually I'd hit Steve
up directly on IRC and he'd point me in the right direction, but he
wasn't online today.  But I guess the "IRC terseness" carried on to the
mail. ;).  I guess I was wondering if anyone else had seen this before
digging in.

I digress.

All I was doing was enabling the basic function-graph tracer, enabling
the tracer, run a test, stopping the tracer, and taking a look at the
"trace" output by grepping for functions that I knew should have hit.

In -rc7, grep turns up empty and I can't seem to find evidence that any
of my code was hit, even though other utilities (like top) indicated my
code was indeed running (I could see kthreads belonging to my module use
cpu, for instance).  In addition, the test passes so its not like it may
have skipped over the function I was looking for.  Its just not being
traced for some reason.

Reverting back to -rc6 and a simple recompile + repeat of the same steps
indeed restored the behavior that I was accustomed to.

I noticed that both the output that I could observe, plus the output you
provide above seem to be core-kernel related functions.  I know all the
traces I was looking for were module related.  Therefore, I suspect that
somehow module code (or at least, my module code) is not being
instrumented for some reason.

Kind Regards,
-Greg


--------------enig5B51D15FFF30A06711A74FAB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqWu0AACgkQP5K2CMvXmqGkSwCfQnY4QHcduDGsDvD8QutVA3At
8UMAn1KfvcFfIpe+nWAgp7yONPLpCj7u
=Rx/R
-----END PGP SIGNATURE-----

--------------enig5B51D15FFF30A06711A74FAB--
