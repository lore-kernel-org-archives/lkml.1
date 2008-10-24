Return-Path: <linux-kernel-owner+w=401wt.eu-S1757888AbYJXSB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbYJXSB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 14:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbYJXSBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 14:01:50 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:26035 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbYJXSBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 14:01:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LQ2e0gv9TDDofM8dKGHSo/BIKKF/nOGpE3T4Fhr5yahN0yZ4FCTfaMDPoa/Eh2Aize
         p0LQXx7E3foaRZ68aRdFLiRi9nY1CY3kEexF/MUrI7YPvN/hA1iBj76U+iTMEk+YWXeX
         YNNRO0rABJaxCJfpbfZfH9c7Ovh8+ZIaHJg60=
Message-ID: <12c511ca0810241101u46b338e0j10307b1ef76ced21@mail.gmail.com>
Date: Fri, 24 Oct 2008 11:01:48 -0700
From: "Tony Luck" <tony.luck@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH] get rid if __cpuinit and __cpuexit
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
In-Reply-To: <20081022180737.289ab7ee@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081022153054.335ce51e@infradead.org>
	 <12c511ca0810221712n665b4c75t5d07c7f4d5e006b2@mail.gmail.com>
	 <20081022180737.289ab7ee@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 6:07 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> interesting... I don't see how that can be unless the checks originally
> had a bug and did not complain about a reference to __init(data) memory
> from inside __cpuinit memory...
> (in which case my point of this being too complex and fragile is
> proven ;-)

Definitely too complex and fragile.  I rebuilt with
CONFIG_DEBUG_SECTION_MISMATCH=y
and found that this patch just shuffled everything
around.  Only 4 mismatch warnings were the same
with this patch, 11 old warnings went away, but
14 new ones appeared!

-Tony
