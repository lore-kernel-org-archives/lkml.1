Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab0BNRca (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 12:32:30 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:25788 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab0BNRc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 12:32:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Ex1C4bDSORFJEMoHrtrarlfzNixAmTxSCc8AqaPAUPaQLoFQSigPhKK26kn/WTyBCX
         seegkOhe0jvgDhxLCp/eTW+1mDc8boZEt/999hbMnW/3+0AsVcDsUFPnosZRq84fczHi
         nIOMLqnPtZ4jSBrNblzVTxaBkBKb+eC66bsuI=
Message-ID: <4B7833A4.90905@gmail.com>
Date: Sun, 14 Feb 2010 18:32:20 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-9.3 Thunderbird/3.0.1
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@suse.de>
Subject: Re: oops in uevent_helper [was: mmotm 2010-01-13-12-17 uploaded]
References: <201001132042.o0DKgaSR027272@imap1.linux-foundation.org> <4B50C2FA.4020100@gmail.com> <4B50FC78.9010107@gmail.com> <20100122155237.e93a1c55.akpm@linux-foundation.org> <4B730EE3.4080405@gmail.com> <20100211205745.GA18202@basil.fritz.box> <20100211142513.b1fd6e7a.akpm@linux-foundation.org> <20100212052126.GA21783@one.firstfloor.org> <20100211212708.aa5bec1f.akpm@linux-foundation.org> <20100212170624.GB27303@hmsreliant.think-freely.org>
In-Reply-To: <20100212170624.GB27303@hmsreliant.think-freely.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2010 06:06 PM, Neil Horman wrote:
> Fix up remaining references to uevent_helper to play nice with Andi's
> uevent_helper/rcu changes.
> 
> Some changes were made recently which modified uevent_helper to be an rcu
> protected pointer, rather than a static char array.  This has led to a few
> missed points in which the sysfs path still assumed that:
> 1) the uevent_helper symbol could still be accessed safely without
> rcu_dereference
> 2) that the sysfs path could copy data to that pointer safely.
> 
> I've fixed this by chaging the sysfs path so that it duplicates the string on
> uevent_helper_store, and freeing it (only if it doesn't point to the
> CONFIG_DEFAULT_UEVENT_HELPER string), in a call_rcu post-quiescent point.  I've
> also fixed up the remaining references to the uevent_helper pointers to use
> rcu_dereference.
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

Tested-by: Jiri Slaby <jirislaby@gmail.com>

-- 
js
