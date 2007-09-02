Return-Path: <linux-kernel-owner+w=401wt.eu-S933739AbXIBIG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933739AbXIBIG2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 04:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbXIBIGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 04:06:14 -0400
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:37149 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750886AbXIBIGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 04:06:11 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Junio C Hamano <gitster@pobox.com>, git@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] GIT 1.5.3
References: <7vodglr32i.fsf@gitster.siamese.dyndns.org>
	<46DA5F33.2020005@zytor.com>
From: David Kastrup <dak@gnu.org>
Date: Sun, 02 Sep 2007 10:06:00 +0200
In-Reply-To: <46DA5F33.2020005@zytor.com> (H. Peter Anvin's message of "Sun\, 02 Sep 2007 07\:58\:59 +0100")
Message-ID: <85odgltrtj.fsf@lola.goethe.zz>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Junio C Hamano wrote:
>>
>> * For people who need to import from Perforce, a front-end for
>>   fast-import is in contrib/fast-import/.
>>
>
> There seems to be an issue with this and RPMS.
>
> In particular, there is no longer a git-p4 RPMS, which prevents git
> from getting upgraded at all by yum.
>
> Anyone who knows yum well enough to explain what needs to be done so
> that yum knows this is obsolete?

Probably a matter of the correct spec file.  In auctex.spec, we have

Summary: 	Enhanced TeX modes for Emacsen
Name: 		auctex
Version: 	11.84
Release: 	1%{distri}
License: 	GPL
Group: 		%{commongroup}
URL: 		http://www.gnu.org/software/auctex/
Source0:        ftp://ftp.gnu.org/pub/gnu/auctex/%{name}-%{version}.tar.gz
BuildArchitectures: noarch
BuildRoot: 	%{_tmppath}/%{name}-root

%description
AUCTeX is [...]

%package emacs
Summary: 	Enhanced TeX modes for GNU Emacs
Group:          %{commongroup}
Requires: 	emacs >= 21
Obsoletes:      ge_auc emacs-auctex auctex preview-latex-emacs
Conflicts:      emacspeak < 18
Provides:       auctex


So auctex-emacs obsoletes the previous "auctex" package and some other
packages.  It also provides "auctex" since some other packages might
require it.

Basically, you need to provide everything that a third-party package
might have asked for, and you need to obsolete everything that you
intend to replace.

-- 
David Kastrup, Kriemhildstr. 15, 44793 Bochum
