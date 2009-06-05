Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbZFEJW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbZFEJW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 05:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbZFEJWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 05:22:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57978 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbZFEJWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 05:22:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Amerigo Wang <amwang@redhat.com>
Subject: Re: [Patch] kbuild: fix headers_check.pl
Date: Fri, 5 Jun 2009 10:21:50 +0100
User-Agent: KMail/1.11.90 (Linux/2.6.30-5-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, sam@ravnborg.org,
       linux-kbuild@vger.kernel.org
References: <20090605021419.7905.89870.sendpatchset@localhost.localdomain>
In-Reply-To: <20090605021419.7905.89870.sendpatchset@localhost.localdomain>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200906051021.51726.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19PuUoAUsyNN/TnUE0Oxk3iSsVsigjrB+BDpFt
 dStxYaR+CHb1PGCl9N8xz5UN0JfVR6oDqJYhi7hycHBOREWgMJ
 9ix1kiD3KjFn0TOwESrIA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 June 2009, Amerigo Wang wrote:
> -sub check_prototypes
> +sub check_declarations
>  {
> -       if ($line =~ m/^\s*extern\b/) {
> -               printf STDERR "$filename:$lineno: extern's make no sense in userspace\n";
> +       if ($line =~m/^\s*extern\b/) {
> +               if ($line =~ m/^\s*extern\b.*\(.*\)/) {
> +                       printf STDERR "$filename:$lineno: extern's make no sense in userspace\n";
> +               } else {
> +                       printf STDERR "$filename:$lineno: exporting global variable to userspace is suspicious\n";
> +               }
>         }
>  }

I don't think we really need that distinction here, the old
text applies to both. But please find a way to get rid of
the "extern's".

http://angryflower.com/bobsqu.gif

	Arnd <><
