Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbZGTRYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbZGTRYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 13:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbZGTRYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 13:24:15 -0400
Received: from web50102.mail.re2.yahoo.com ([206.190.38.30]:43460 "HELO
	web50102.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753297AbZGTRYO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 13:24:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=xfbaMxjYbssuBLPdl1BFg1fSbKzt7djQ2iB2P6mEe1YkZ3/HzuinKIgD5E6OuYSZe8el3qWSMIDt/butSKE188boVOJpRK9aP3T0EytR3gcVvpKKysoKaWbGCZGMG9Lxei9/Mt261b40c2Kx2OdTxKb/5l3U7egNLRazOoPUiUk=;
Message-ID: <219399.26774.qm@web50102.mail.re2.yahoo.com>
X-YMail-OSG: sOX4cNwVM1nqYk9Jdgh2SShBzBVASBIqdX6o1AWNhZpNrYo7k3zrzYz6IbR3UO.QjVuECw3NYWWzLLoSLaCNpV0ywma4cEljpMxX9EetdFv4Fhn1b12mJbM9bjTWWDe9tFC.BBwf9VjVLb2Xws1X4gfwsfzShUDkfGY5ILhmZ_JhikukMjpTodzBsC5qCGCk8xpIqHgNrG4GQgZPPA1gfVo5Mz0z4GCE9wGPyd1evpkh8XNHQpp6sA73awHkT9F4IO6KMATHMqmshA82QTGSrbTw_MPlPtUdSRFDJ.P95obWo_piNaOdKt5TUcV0M0sHFugDKN73efhuAblAj.ut
X-Mailer: YahooMailClassic/6.0.18 YahooMailWebService/0.7.338.1
Date: Mon, 20 Jul 2009 10:24:13 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [RFC PATCH 0/14] amd64_edac: marry mcheck to amd64 edac
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, aris@redhat.com,
       Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
In-Reply-To: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 7/20/09, Borislav Petkov <borislav.petkov@amd.com> wrote:

> From: Borislav Petkov <borislav.petkov@amd.com>
> Subject: [RFC PATCH 0/14] amd64_edac: marry mcheck to amd64 edac
> To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, norsk5@yahoo.com, aris@redhat.com
> Cc: linux-kernel@vger.kernel.org, x86@kernel.org
> Date: Monday, July 20, 2009, 10:12 AM
> Hi all,
> 
> this is the first version of the attempt to forward MCE
> information to
> the amd64 EDAC module for further decoding. When the MCE
> handler gets
> invoked and the EDAC module is loaded, here's how a decoded
> MCE looks
> like:

This looks good. I will apply and test shortly.

Question: are you planning to have the ErrAddr decoding added later, where we decode to an actual DIMM label, as stored in the MCI structure for that error address?

If so, okay. If not, then we must have that to be displayed so the maintenance techs know exactly which DIMM to pull. Only the amd64 edac module has that and the controller registers to properly decode it.

the MCE has a poller thread as well for CORRECTED errors. Its cycle is abt 5 minutes I believe, while EDAC is 1 second. That is another item we need to sort out

thanks

doug t

> 
> Disabling lock debugging due to kernel taint
> 
> <0>HARDWARE ERROR
> CPU 3: Machine Check Exception:       
>         4 Bank 0: b20040001c000175
> TSC 714e9b73cf 
> PROCESSOR 2:100f22 TIME 1247237579 SOCKET 0 APIC 3
> MC0_STATUS: Uncorrected error, report: yes, MiscV: invalid,
> CPU context corrupt: yes
>  Data Cache Error: Data/Tag Evict error.
>  Transaction: Evict, Type: Data, Cache Level: L1
> This is not a software problem!
> <0>Run through mcelog --ascii to decode and contact
> your hardware vendor
> Machine check: Processor context corrupt
> Kernel panic - not syncing: Fatal machine check on current
> CPU
> Pid: 4817, comm: cc1 Tainted: G   M 
>      2.6.31-rc2-00218-g78848b0-dirty
> #42
> Call Trace:
>  <#MC>  [<ffffffff8134a17a>]
> panic+0xaf/0x178
>  [<ffffffff812b5d9e>] ? decode_mce+0x47e/0x540
>  [<ffffffff81019210>] ? print_mce+0x90/0x110
>  [<ffffffff810193e7>] mce_panic+0x157/0x180
>  [<ffffffff81019de7>] do_machine_check+0x757/0x930
>  [<ffffffff8134d96d>] ?
> trace_hardirqs_off_thunk+0x3a/0x3c
>  [<ffffffff8134e9cb>] machine_check+0x1b/0x20
>  <EOE>
> 
> Clearly, the "Run through mcelog... " line is redundant now
> :) since
> there's no need for userspace decoding anymore and the
> original EDAC
> functionality (polling workqueue) is still preserved. The
> code currently
> uses EDAC to decode DRAM ECC errors but this could clearly
> be extended
> to handle all valid addresses acquired from MCi_ADDR
> registers.
> 
> Comments and further suggestions are most welcome.
> 
> Thanks,
> Boris.
> 
>  arch/x86/kernel/cpu/mcheck/mce.c    | 
>   7 +
>  drivers/edac/amd64_edac.c       
>    |  484
> +++++++++++++++++++++--------------
>  drivers/edac/amd64_edac.h       
>    |   67 ++---
>  drivers/edac/amd64_edac_dbg.c   
>    |    2 +-
>  drivers/edac/amd64_edac_err_types.c |  126
> +++++-----
>  5 files changed, 382 insertions(+), 304 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
