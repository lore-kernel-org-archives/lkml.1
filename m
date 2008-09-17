Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691AbYIQE4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbYIQE4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 00:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbYIQE4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 00:56:15 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:48832 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbYIQE4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 00:56:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=lUQAe4Gu9wOOUov5RtzI1vD/SZ/mMm1M3ep/CjMvF2EyyiDt59MeuFYzPDt0uV2a57
         0uRzaTyZ1nSJmHsBrmxeO44c9Ry9GsvaSY4P0DM8Yebq0ir7sDS4pFoiNIJcEuVyCfUO
         +IEsvVVqr7OAnq8tjRJVhcp7XkV+uSBYGSn8w=
Message-ID: <76366b180809162156x1c3a8785refaaa4e2883ae2ac@mail.gmail.com>
Date: Wed, 17 Sep 2008 00:56:13 -0400
From: "Andrew Paprocki" <andrew@ishiboo.com>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: Endless ACPI errors on Linus tree (5b664cb235)
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Robert Moore" <robert.moore@intel.com>, "Len Brown" <lenb@kernel.org>,
       "Robert Gough" <robert.gough@intel.com>, "Takashi Iwai" <tiwai@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <488774F1.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <s5hzlof1ll2.wl%tiwai@suse.de> <4880DE15.76E4.0078.0@novell.com>
	 <s5habgfdu5e.wl%tiwai@suse.de>
	 <20080718165814.GF32051@basil.nowhere.org>
	 <s5hmykexm53.wl%tiwai@suse.de> <488460E0.76E4.0078.0@novell.com>
	 <20080721084354.GB20258@basil.nowhere.org>
	 <488731DD.76E4.0078.0@novell.com>
	 <9D39833986E69849A2A8E74C1078B6B3B68DDD@orsmsx415.amr.corp.intel.com>
	 <488774F1.76E4.0078.0@novell.com>
X-Google-Sender-Auth: 4e8177ab246d0ebf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 12:14 PM, Jan Beulich <jbeulich@novell.com> wrote:
>>>> "Moore, Robert" <robert.moore@intel.com> 23.07.08 17:43 >>>
>>Couple of thoughts.
>>
>>I think we must use the V2 field if it is present and the address value
>>is > 32 bits.
>>
>>What if the V2 address is < 32 bits but does not match the V1 address?
>
> The v2 address was used already before this patch, the patch just
> (initially) tried to make things consistent to use the v2 bit width along
> with the v2 address. That didn't work out. I certainly think there's room
> for improvement, but perhaps (at least at present) of more academical
> nature: If the v2 widths indicate a value wider than the v1 ones, then
> we could still try to use the v2 field. The breakages reported so far
> were only in the v2 widths being smaller than the v1 ones...

Jan,

I finally was able to test this patch with the hardware which
exhibited the original problem. The system works as expected and it
prints out the kernel warning, which is also expected:

FADT: X_PM1a_EVT_BLK.bit_width (8) does not match PM1_EVT_LEN (4)

Let me know if you'd like me to try anything else on this hardware. I
dumped the BIOS tables and verified that the bit width field is
incorrect, so there doesn't seem to be much else to do.

-Andrew
