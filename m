Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbZGGLk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbZGGLk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 07:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbZGGLkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 07:40:49 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:57424 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbZGGLks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 07:40:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=gFFww7Xv2jNhAi6wg1oUdYfdRn27Swx0hAlaIKwKudtSzPWv7zRFiwWcl2+UKodyum
         G+5whLSrlm5faMUSgeLxl8Ja34+5OfhUrygPOxKahFR6R8CpjaG9QiUHZ+zOKBczGSoL
         ID0lwNo0NpF4fWsmsNKdTyNVzG2/eQ3xi1snI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13318] AGP doesn't work anymore on nforce2
Date: Tue, 7 Jul 2009 13:46:25 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30-next-20090617-09943-g5d77a4c; KDE/4.2.4; i686; ; )
Cc: Shaohua Li <shaohua.li@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>,
       Jerome Glisse <glisse@freedesktop.org>,
       Karsten Mehrhoff <kawime@gmx.de>,
       Michel =?iso-8859-1?q?D=E4nzer?= <michel@daenzer.net>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera> <20090707021254.GA25184@sli10-desk.sh.intel.com> <200907071300.12565.rjw@sisk.pl>
In-Reply-To: <200907071300.12565.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907071346.29408.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 July 2009 13:00:11 Rafael J. Wysocki wrote:
> On Tuesday 07 July 2009, Shaohua Li wrote:
> > On Tue, Jul 07, 2009 at 08:00:36AM +0800, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of regressions introduced between 2.6.29 and 2.6.30.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> > > be listed and let me know (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13318
> > > Subject		: AGP doesn't work anymore on nforce2
> > > Submitter	: Karsten Mehrhoff <kawime@gmx.de>
> > > Date		: 2009-04-30 8:51 (68 days old)
> > > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=59de2bebabc5027f93df999d59cc65df591c3e6e
> > > References	: http://marc.info/?l=linux-kernel&m=124108156417560&w=4
> > > Handled-By	: Shaohua Li <shaohua.li@intel.com>
> > Can anybody else help look at this issue? I really have no idea why this could
> > happens.
> 
> Quirky hardware?

Could be a weird interaction between CONFIG_X86_USE_3DNOW and AGP
or "simply" some timing issue.  Either way it means a lot of "fun". ;)

The latter theory can be verified by adding some {u,m}delay() to
agp_generic_alloc_page{s}() and the former one with:

---
 arch/x86/Kconfig.cpu |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/arch/x86/Kconfig.cpu
===================================================================
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -363,7 +363,7 @@ config X86_USE_PPRO_CHECKSUM
 
 config X86_USE_3DNOW
 	def_bool y
-	depends on (MCYRIXIII || MK7 || MGEODE_LX) && !UML
+	depends on (MCYRIXIII || MGEODE_LX) && !UML
 
 config X86_OOSTORE
 	def_bool y
