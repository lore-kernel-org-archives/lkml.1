Return-Path: <linux-kernel-owner+w=401wt.eu-S1759945AbYFLMZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945AbYFLMZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760672AbYFLMZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:25:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:15807 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757419AbYFLMZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:25:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=siS7OvrTIIUWk3T12ZXx9mgutnnsYGF5Og7nmpcfpzbXtapQVpUyR17D0JmgMeMCTx
         8J7NkPeqMQAKj0fUY55ON7ifmVHUZHEzWrTPXMfO9C7E8hA4T79sns1xPKG58KmoQCxG
         5eTXXc8NgsjXSAjdIisI8mLB0+9ng0fxQFSwE=
Message-ID: <86802c440806120525v2da860bfyf05eb8ec6b9943d0@mail.gmail.com>
Date: Thu, 12 Jun 2008 05:25:03 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: Confusions with reserve_early, reserve_bootmem, e820, efi, ... on x86_64
Cc: "Ingo Molnar" <mingo@elte.hu>, "Bernhard Walle" <bwalle@suse.de>,
       "Johannes Weiner" <hannes@saeurebad.de>,
       "Huang, Ying" <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
       "Jack Steiner" <steiner@sgi.com>
In-Reply-To: <20080612050609.88a8cf7f.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080612050609.88a8cf7f.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 3:06 AM, Paul Jackson <pj@sgi.com> wrote:
> Bernhard, Johannes, Huang, and Yinghai:
>
> I am running into some complications with reserve_bootmem vs
> reserve_early, and a reserve_early of "EFI memmap" in the
> efi_reserve_early() routine conflicting with reserve_early of
> "BIOS reserved" in reserve_ebda_region().
>
> This is on x86_64 arch, using Ingo's x86-latest, with possibly
> still buggy EFI firmware in a lab system I'm helping to develop.
>
> I have three concerns:
>
>  1) The find_overlapped_early() check called from reserve_early is
>    failing on my lab system , causing panic, when it tries to
>    register "EFI memmap" at addresses <0xe0660, 0xe0778> that
>    overlaps with the "BIOS reserved" early reserve at addresses
>    <0x9f000, 0x100000>

then reserve_ebda_region() need to be fixed.

YH
