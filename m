Return-Path: <linux-kernel-owner+w=401wt.eu-S965888AbXHaRQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965888AbXHaRQ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 13:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965394AbXHaRQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 13:16:20 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:20197 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965421AbXHaRQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 13:16:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=OFeJiFrLxzDhyJCyYmj273fM6LkI28DUYZHY5Nq1fNYVWpowerVbMFe8UVkwFr8Hu5BDpkjH06iBSR8x+3k6J+CXTRaExYr7ONbu+k1wrXWID9az90nHTWH2jQ+exGvZkr7dQs/SbIEEzTUBa7kPa8r2v3dqf4WQmniZPysjOJo=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@logfs.org>
Subject: Re: 4KSTACKS + DEBUG_STACKOVERFLOW harmful
Date: Fri, 31 Aug 2007 18:16:09 +0100
User-Agent: KMail/1.9.1
Cc: Eric Sandeen <sandeen@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
References: <46D5F462.9010401@redhat.com> <200708311211.25143.vda.linux@googlemail.com> <20070831143527.GB5328@lazybastard.org>
In-Reply-To: <20070831143527.GB5328@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708311816.09554.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 August 2007 15:35, Jörn Engel wrote:
> On Fri, 31 August 2007 12:11:25 +0100, Denys Vlasenko wrote:
> > 
> > KSYM_NAME_LEN = 128 sounds stupid. The name which is wider than 80 chars??
> > Kernel shouldn't have names that long.
> > Say, 50 chars ought to be enough.
> 
> Might be an enforcement problem, unless someone also writes a
> check_name_len.pl or so.

It's trivial to do it in scripts/mksysmap (script which generates System.map)

Currently it simply does

$NM -n $1 | grep -v '\( [aUw] \)\|\(__crc_\)\|\( \$[adt]\)' > $2

--
vda
