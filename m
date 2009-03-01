Return-Path: <linux-kernel-owner+w=401wt.eu-S1756517AbZCAEO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbZCAEO5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 23:14:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbZCAEOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 23:14:47 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:59820 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbZCAEOq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 23:14:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KMKKGxIX7DOry4bXVbnYBeSL55LUpDQpQQR7SvHtXp43mIDouYq690sTsANer4+IrF
         EetednKVbsWX7UNOqD1zkuxyuRmeazCNK3Wf9Orc8dcLvUFws+H1BKINsuDvDttbnXi4
         qw4wKtx/8CmGNCzErDCtFF2Y8WUdV+VoVxlB8=
MIME-Version: 1.0
In-Reply-To: <49A965AD.10701@redhat.com>
References: <49A965AD.10701@redhat.com>
Date: Sat, 28 Feb 2009 20:14:44 -0800
X-Google-Sender-Auth: e23fa5a5449ece6d
Message-ID: <86802c440902282014he17bb6an1f59872ef30db0c5@mail.gmail.com>
Subject: Re: [PATCH] Fix e820 end address with EFI
From: Yinghai Lu <yinghai@kernel.org>
To: Brian Maly <bmaly@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 8:26 AM, Brian Maly <bmaly@redhat.com> wrote:
>
>   On some EFI systems (i.e. Apple) EFI runtime is mapped into higher mem
> regions. These EFI mem regions are not always taken into consideration when
> max_pfn is calculated in setup.c being that e820_end_of_ram_pfn() only
> counts
> mappings types marked as usable (E820_RAM). Currently we only count to the
> last
> usable e820 address range and nothing beyond. EFI can be mapped anywhere
> within
> e820 and is not always marked as usable e820, and so EFI runtime may be
> missed
> if mapped somewhere beyond last usable e820. This patch attempts to resolve
> this problem by including all E820 mappings when EFI is enabled, so that
> the entire e820 (and EFI runtime area) is included in computing max_pfn.
> Tested
> on a MacBook Pro 3.1 and resolves the issue (system now boots w/elilo+grub &
> EFI).
>

it seems you should check and enable directly mapping when EFI runtime
service is enabled.

YH
