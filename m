Return-Path: <linux-kernel-owner+w=401wt.eu-S1756784AbZADIC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbZADIC2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 03:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbZADICT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 03:02:19 -0500
Received: from ellpspace.math.ualberta.ca ([129.128.207.67]:60508 "EHLO
	ellpspace.math.ualberta.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750967AbZADICS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 03:02:18 -0500
X-Greylist: delayed 2770 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Jan 2009 03:02:18 EST
Date: Sun, 4 Jan 2009 00:15:55 -0700
From: Michal Jaegermann <michal@ellpspace.math.ualberta.ca>
To: Rob Landley <rob@landley.net>
Cc: Ingo Oeser <ioe-lkml@rameria.de>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/3]: Replace kernel/timeconst.pl with
	kernel/timeconst.sh
Message-ID: <20090104071555.GA1074@ellpspace.math.ualberta.ca>
References: <200901020207.30359.rob@landley.net> <200901020213.30658.rob@landley.net> <200901031328.23079.ioe-lkml@rameria.de> <200901031936.04642.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200901031936.04642.rob@landley.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2009 at 07:36:04PM -0600, Rob Landley wrote:
> On Saturday 03 January 2009 06:28:22 Ingo Oeser wrote:
> > > +for i in "MSEC 1000" "USEC 1000000"
> > > +do
> > > +	NAME=$(echo $i | awk '{print $1}')
> >
> > cut -d' ' -f1  does the same
> >
> > > +	PERIOD=$(echo $i | awk '{print $2}')
> >
> > cut -d' ' -f2  does the same
> 
> From a standards perspective 
> http://www.opengroup.org/onlinepubs/9699919799/utilities/cut.html vs 
> http://www.opengroup.org/onlinepubs/9699919799/utilities/awk.html is probably 
> a wash, but from a simplicity perspective using the tool that _isn't_ its own 
> programming language is probably a win. :)

Vagaries of 'cut' aside you can limit yourself here to just shell:

set_name_period () {
   NAME=$1 ; PERIOD=$2
}
for i in "MSEC 1000" "USEC 1000000"
do
   set_name_period $i
....
done

or you may skip a shell function and do 'set $i' within a loop plus
assignments of $1 and $2 to NAME and PERIOD but that overwrites original
positional parameters (which may be already not important).

   Michał
