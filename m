Return-Path: <linux-kernel-owner+w=401wt.eu-S1752435AbXA1P25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbXA1P25 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 10:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbXA1P25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 10:28:57 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:23984 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbXA1P24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 10:28:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=IpGla4UGMkGgseq1Uf/bPLw1bzVFmldxgWzDmgcP4uprgK4FLlJuGbvxuK58mUJAChFLyKTwlD2gLmnG0/fJDffAVdzYy3JEidS1QjrMRPE/qzqDq3B+oI4ak6FeT63NpWL9DTjnnDeQiFgN0VdR0nKeEeBGUk7LvKc6r+EkYWg=
Date: Sun, 28 Jan 2007 18:28:42 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@osdl.org>, Alexey Dobriyan <adobriyan@openvz.org>,
       devel@openvz.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] lutimesat: simplify utime(2)
Message-ID: <20070128152842.GB5549@martell.zuzino.mipt.ru>
References: <20070126112142.GA11128@localhost.sw.ru> <20070126124120.f8f78623.akpm@osdl.org> <200701270035.42323.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200701270035.42323.arnd@arndb.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 27, 2007 at 12:35:42AM +0100, Arnd Bergmann wrote:
> On Friday 26 January 2007 21:41, Andrew Morton wrote:
> > I'm somewhat surprised that this wasn't done earlier.  I wonder if there's
> > some subtle reason why this won't work.   How well tested is this?
> 
> http://www.opengroup.org/onlinepubs/000095399/functions/utimes.html
> lists a slight difference between utime and utimes in the handling
> of EPERM/EACCESS:
> 
> > The utimes() function shall fail if:
> > [EACCES] Search permission is denied by a component of the path prefix;
> >  or the times argument is a null pointer and the effective user ID of the
> >  process does not match the owner of the file and write access is denied.
> > [EPERM] The times argument is not a null pointer and the calling process'
> >  effective user ID has write access to the file but does not match the
> >  owner of the file and the calling process does not have the appropriate
> >  privileges.
> >
> > The utime() function shall fail if:
> > [EACCES]  Search permission is denied by a component of the path prefix;
> >  or the times argument is a null pointer and the effective user ID of the
> >  process does not match the owner of the file, the process does not have
> >  write permission for the file, and the process does not have appropriate
> >  privileges.
> > [EPERM] The times argument is not a null pointer and the calling process'
> >  effective user ID does not match the owner of the file and the calling
> >  process does not have the appropriate privileges.
> 
> I don't really understand how that should be implemented in different
> ways, but it might be the reason that we have separate functions.

Present sys_utime() and do_utimes() are identical, except the former
does direct getusering into new attributes, and the latter accept "int
dfd" instead of hardcoded current working directory.

