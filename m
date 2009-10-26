Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbZJZQFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbZJZQFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 12:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbZJZQFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 12:05:47 -0400
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:48917 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752945AbZJZQFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 12:05:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=cFcuH+lBQ/HCbhVc2tPVozyVomOCHPro6RfK8F3aHHqvoOgE3KMYOr/2lhCZW5h7WDxiKfg5TdgKKOMuJXjCKS5F54ZcPBz1Sc1AGDvjRtx/rRv1uiyRyqxW3ha2Uc+2;
Date: Mon, 26 Oct 2009 09:05:48 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, eric@anholt.net
Subject: Re: no video output after suspend after "drm/i915: force mode set
 at lid open time"
Message-ID: <20091026090548.2d4e20a9@jbarnes-g45>
In-Reply-To: <4AE4BBBC.2070809@gmail.com>
References: <4AE4BBBC.2070809@gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Oct 2009 21:57:32 +0100
Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com> wrote:

> Hello,
> 
> i lost video output, screen stays black, after suspend after commit 
> c1c7af60892070e4b82ad63bbfb95ae745056de0 "drm/i915: force mode set at 
> lid open time".
> 
> I'm attaching my dmesg with 2.6.32-rc5 (actually
> 964fe080d94db82a3268443e9b9ece4c60246414), my bisect log and my
> config.
> 
> git bisect response:
> 
> c1c7af60892070e4b82ad63bbfb95ae745056de0 is the first bad commit
> commit c1c7af60892070e4b82ad63bbfb95ae745056de0
> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date:   Thu Sep 10 15:28:03 2009 -0700
> 
>      drm/i915: force mode set at lid open time
> 
>      Some laptop platforms will disable pipes and/or planes at lid
> close time
>      and not restore them when the lid is opened again.  So catch the
> lid event, and if the lid was opened, force a mode restore.
> 
>      Fixes fdo bug #21230.
> 
>      Acked-by: Matthew Garrett <mjg@redhat.com>
>      Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>      Signed-off-by: Eric Anholt <eric@anholt.net>

I wonder if this is the real problem...  This patch introduced an issue
that was fixed by 06891e27a9b5dba5268bb80e41a283f51335afe7 that could
cause a blank screen on lid open or resume, depending on how lid events
were delivered.  Should be easy enough to test though, you can remove
the whole

+       if (acpi_lid_open())
+               drm_helper_resume_force_mode(dev);

block and see if that also helps (in the current tree there's a lock
taken around the force_mode call, you'll need to remove those lines too
for testing).
-- 
Jesse Barnes, Intel Open Source Technology Center
