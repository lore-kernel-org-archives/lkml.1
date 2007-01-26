Return-Path: <linux-kernel-owner+w=401wt.eu-S1751770AbXAZXgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbXAZXgG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 18:36:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbXAZXgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 18:36:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:65111 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbXAZXgE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 18:36:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 1/3] lutimesat: simplify utime(2)
Date: Sat, 27 Jan 2007 00:35:42 +0100
User-Agent: KMail/1.9.5
Cc: Alexey Dobriyan <adobriyan@openvz.org>, devel@openvz.org,
       linux-kernel@vger.kernel.org
References: <20070126112142.GA11128@localhost.sw.ru> <20070126124120.f8f78623.akpm@osdl.org>
In-Reply-To: <20070126124120.f8f78623.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200701270035.42323.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX1+Krwq45yIq/sapyUhbZtZsqp94lyT+NgcDIl9Yn69GLFeWIznlTpBNUz2ndd28MP1LxhimjlTaSl4+Z/zlA9LAqVvs7wi7ltjiKxKMoXjGww==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 January 2007 21:41, Andrew Morton wrote:
> I'm somewhat surprised that this wasn't done earlier.  I wonder if there's
> some subtle reason why this won't work.   How well tested is this?

http://www.opengroup.org/onlinepubs/000095399/functions/utimes.html
lists a slight difference between utime and utimes in the handling
of EPERM/EACCESS:

> The utimes() function shall fail if:
> [EACCES] Search permission is denied by a component of the path prefix;
>  or the times argument is a null pointer and the effective user ID of the
>  process does not match the owner of the file and write access is denied.
> [EPERM] The times argument is not a null pointer and the calling process'
>  effective user ID has write access to the file but does not match the
>  owner of the file and the calling process does not have the appropriate
>  privileges.
>
> The utime() function shall fail if:
> [EACCES]  Search permission is denied by a component of the path prefix;
>  or the times argument is a null pointer and the effective user ID of the
>  process does not match the owner of the file, the process does not have
>  write permission for the file, and the process does not have appropriate
>  privileges.
> [EPERM] The times argument is not a null pointer and the calling process'
>  effective user ID does not match the owner of the file and the calling
>  process does not have the appropriate privileges.

I don't really understand how that should be implemented in different
ways, but it might be the reason that we have separate functions.

	Arnd <><
