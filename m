Return-Path: <linux-kernel-owner+w=401wt.eu-S967794AbXEHEna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967794AbXEHEna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 00:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967753AbXEHEn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 00:43:26 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:8689 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967732AbXEHEnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 00:43:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ABgCB5l4NnwIiOeL4mtY+x6t9U+VjBzoUB9dMGb5sOCnNI9BaJu+4p8P0CFVD27H7W1+5E1dmmpMGyZKPeHRQE8pc+Y9sqfaFiDLCsj1XkgZOuSS6z/1fG16s1YdqoWBnuee/5cstZGcItdw6dR32DWbO6ncwPwsInItSTkf6XM=
Message-ID: <787b0d920705072143q63e56f23j18c6b0dbfb270883@mail.gmail.com>
Date: Tue, 8 May 2007 00:43:24 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: arvidjaar@mail.ru, hirofumi@mail.parknet.co.jp,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: Long file names in VFAT broken with iocharset=utf8
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov writes:

> This was posted in one of Russian forums. It was not possible to
> archive (under Linux, using tar) vfat directory where files had
> long Russian names (really long - over 150 - 170 characters) - tar
> returned stat failure. When looking with plain ls, file names
> appeared truncated.

I have an idea to deal with this, but first a rant...

At two bytes per character, you get 127 characters in a filename.
That's wider than the standard 80-column display, and far wider
than the 28 or 29 characters that an "ls -l" has room for. In a
GUI file manager or file dialog box, you'll have to scroll sideways.
In a web browser directory listing, you'll almost certainly have
to scroll sideways. Must of this even applies to Windows tools.

In other words, this is user error. Somebody thought that a filename
was a place to store a document, probably a README file. What next,
shall we MIME-encode an icon into the filename?

Fix: the vfat driver should use the 8.3 name for such files.
