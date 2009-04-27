Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbZD0LnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbZD0LnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 07:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbZD0LnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 07:43:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:46862 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbZD0LnG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 07:43:06 -0400
MIME-Version: 1.0
In-Reply-To: <1240821139-7247-24-git-send-email-monstr@monstr.eu>
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu>
	 <1240821139-7247-16-git-send-email-monstr@monstr.eu>
	 <1240821139-7247-17-git-send-email-monstr@monstr.eu>
	 <1240821139-7247-18-git-send-email-monstr@monstr.eu>
	 <1240821139-7247-19-git-send-email-monstr@monstr.eu>
	 <1240821139-7247-20-git-send-email-monstr@monstr.eu>
	 <1240821139-7247-21-git-send-email-monstr@monstr.eu>
	 <1240821139-7247-22-git-send-email-monstr@monstr.eu>
	 <1240821139-7247-23-git-send-email-monstr@monstr.eu>
	 <1240821139-7247-24-git-send-email-monstr@monstr.eu>
Date: Mon, 27 Apr 2009 21:43:06 +1000
Message-ID: <1d3f23370904270443u4ef547b3hab25b65babe329f3@mail.gmail.com>
Subject: Re: [PATCH 23/30] microblaze_mmu_v1: Enable fork syscall for MMU and 
	add fork as vfork for noMMU
From: John Williams <john.williams@petalogix.com>
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 6:32 PM,  <monstr@monstr.eu> wrote:
> From: Michal Simek <monstr@monstr.eu>
>
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> ---
>  arch/microblaze/kernel/entry-nommu.S   |    3 ++-
>  arch/microblaze/kernel/syscall_table.S |    2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/microblaze/kernel/entry-nommu.S b/arch/microblaze/kernel/entry-nommu.S
> index f24b126..89f978a 100644
> --- a/arch/microblaze/kernel/entry-nommu.S
> +++ b/arch/microblaze/kernel/entry-nommu.S
> @@ -10,7 +10,7 @@
>
>  #include <linux/linkage.h>
>  #include <asm/thread_info.h>
> -#include <asm/errno.h>
> +#include <linux/errno.h>
>  #include <asm/entry.h>
>  #include <asm/asm-offsets.h>
>  #include <asm/registers.h>
> @@ -551,6 +551,7 @@ no_work_pending:
>        rtid    r14, 0
>        nop
>
> +sys_fork_wrapper:
>  sys_vfork_wrapper:
>        brid    sys_vfork
>        addk    r5, r1, r0

NACK!  If only it was that easy :)

On noMMU we cannot just silently call vfork() if the application tries
to fork() - you have to return -ENOSYS (or is there a better one?).
This will just require a small sys_fork_wrapper in entry-nommu.S.

John
-- 
John Williams, PhD, B.Eng, B.IT
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com  p: +61-7-30090663  f: +61-7-30090663
