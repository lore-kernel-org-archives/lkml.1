Return-Path: <linux-kernel-owner+w=401wt.eu-S1752393AbYEMQyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbYEMQyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 12:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760400AbYEMQxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 12:53:34 -0400
Received: from rn-out-0910.google.com ([64.233.170.184]:46988 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760356AbYEMQxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 12:53:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OT7+OuHUbpscN8VBBrT+dv1G67zyvvjwEODYaY+vB5seBqgRoY1aoCGy24xDS63/HAl4xMkJurl5JUpd8YdhbXLwNfluSJBQUiG/vKvp1hoOZGbDwYG65hAOFcSGndvmCdZEs3PJKv1llRYtOpdvJ1SvukaUWGI8Lvh8J//c5eU=
Subject: Re: [PATCH 01/12] lib: create common ascii hex array
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide <linux-ide@vger.kernel.org>,
       linux-netdev <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>, Jeff Garzik <jeff@garzik.org>,
       Ingo Molnar <mingo@elte.hu>, Jason Wessel <jason.wessel@windriver.com>,
       David Howells <dhowells@redhat.com>,
       "ralf@linux-mips.org" <ralf@linux-mips.org>,
       Paul Mundt <lethal@linux-sh.org>, Paul Mackerras <paulus@samba.org>
In-Reply-To: <Pine.LNX.4.64.0805122218240.14152@wrl-59.cs.helsinki.fi>
References: <1210619134.24092.51.camel@brick>
	 <Pine.LNX.4.64.0805122218240.14152@wrl-59.cs.helsinki.fi>
Content-Type: text/plain; charset=utf-8
Date: Tue, 13 May 2008 09:53:27 -0700
Message-Id: <1210697607.5938.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-13 at 12:55 +0300, Ilpo Järvinen wrote:
> On Mon, 12 May 2008, Harvey Harrison wrote:
> 
> > Add a common hex array in hexdump.c so everyone can use it.
> > 
> > Add a common hi/lo helper to avoid the shifting masking that is
> > done to get the upper and lower nibbles of a byte value.
> > 
> > Pull the pack_hex_byte helper from kgdb as it is opencoded many
> > places in the tree that will be consolidated.
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> >  
> > -#define hex_asc(x)	"0123456789abcdef"[x]
> > +
> > +extern const char hex_asc[];
> > +#define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
> > +#define hex_asc_hi(x)	hex_asc[((x) & 0xf0) >> 4]
> > +
> > +static inline char *pack_hex_byte(char *buf, u8 byte)
> > +{
> > +	*buf++ = hex_asc_hi(byte);
> > +	*buf++ = hex_asc_lo(byte);
> > +	return buf;
> > +}
> 
> Any idea how much this will bloat kernel once it has, lets say 100 
> users? 5k, 10k?
> 

No more than the existing users do open-coding the same thing all over
the place.  If it becomes a problem, this can be out-of-lined, but
the savings are not much.

Harvey

