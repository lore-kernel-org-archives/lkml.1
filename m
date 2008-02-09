Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbYBITqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbYBITqp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 14:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbYBITqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 14:46:38 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:36354 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058AbYBITqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 14:46:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=KG5HGRZrJ26ogM8jtt5I22L4WS0v8+u5hyJp/xZho8U9pPlOpMpH0g+1KS4DT8uc7dZdPfEvLunJM8DyClaRtEhSkQMJKmFaHeByP6hip3UkNUSMzSssP/EER38w+dKaY3Yr8Uce7T5aHYeVPgw5o0d0591WY6m5XuhhOiunRDM=
Message-ID: <2c0942db0802091146v7b780b7dl4bd745caef900ae7@mail.gmail.com>
Date: Sat, 9 Feb 2008 11:46:33 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [PATCH 1/8] kgdb: core API and gdb protocol handler
Cc: jason.wessel@windriver.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080209172713.GD15568@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1202564114-18587-1-git-send-email-jason.wessel@windriver.com>
	 <1202564114-18587-2-git-send-email-jason.wessel@windriver.com>
	 <20080209172713.GD15568@infradead.org>
X-Google-Sender-Auth: 3096eff8a248f9d9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 9, 2008 9:27 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Sat, Feb 09, 2008 at 07:35:07AM -0600, jason.wessel@windriver.com wrote:
> > +#ifdef __BIG_ENDIAN
> > +             *buf++ = hexchars[(tmp_s >> 12) & 0xf];
> > +             *buf++ = hexchars[(tmp_s >> 8) & 0xf];
> > +             *buf++ = hexchars[(tmp_s >> 4) & 0xf];
> > +             *buf++ = hexchars[tmp_s & 0xf];
> > +#else
> > +             *buf++ = hexchars[(tmp_s >> 4) & 0xf];
> > +             *buf++ = hexchars[tmp_s & 0xf];
> > +             *buf++ = hexchars[(tmp_s >> 12) & 0xf];
> > +             *buf++ = hexchars[(tmp_s >> 8) & 0xf];
> > +#endif
>
> This is really ugly, but I don't really know a good way around it
> either.

void u32_to_hex(u32 val, unsigned char *buf)
{
         int i;

         for (i=7; i>=0; i--) {
                  buf[i] = hexchars[ val & 0x0f ];
                  val >>= 4;
         }
}

         u32_to_hex(tmp_s, buf);
         buf += 8;
