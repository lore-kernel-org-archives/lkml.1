Return-Path: <linux-kernel-owner+w=401wt.eu-S1758376AbYELMtC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376AbYELMtC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 08:49:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbYELMsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 08:48:54 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:50021 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbYELMsx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 08:48:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QSGnTD4cbYF+CPvg4GOH2vLDNl7FKlMtJ5sw8TL8IxZZYTFQSS78niTnmAfYbX398XeRdNbYTj4VwXhfhKXSyWZsIsHn/2K/cYryLPoSOpDzzz1GhkanrkFCOQyDxcEMW9K9J4aQumDlbULumetswY+6ADWLfNWy652PtfiAe60=
Message-ID: <8bd0f97a0805120548k356aff52pdf66acf88fadfebb@mail.gmail.com>
Date: Mon, 12 May 2008 08:48:52 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@logfs.org>
Subject: Re: [PATCH try#2] [MTD/MAPS] Blackfin BF5xx Maps: Handle the case where flash memory and ethernet mac/phy are mapped onto the same async bank
Cc: "Bryan Wu" <bryan.wu@analog.com>, dwmw2@infradead.org,
       will.newton@gmail.com, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080512122650.GA10014@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1202020355.6671.23.camel@roc-laptop>
	 <20080512122650.GA10014@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 8:26 AM, Jörn Engel <joern@logfs.org> wrote:
> On Sun, 3 February 2008 14:32:35 +0800, Bryan Wu wrote:
>> +static void bf5xx_copy_from(struct map_info *map, void *to,
unsigned long from, ssize_t len)
>> +{
>> +     unsigned long i;
>> +     map_word test;
>> +
>> +     if ((unsigned long)to & 0x1) {
>> +             for (i = 0; i < len / 2 * 2; i += 2) {
>> +                     test = bf5xx_read(map, from + i);
>> +                     put_unaligned(test.x[0], (__le16 *)(to + i));
>> +             }
>> +     } else {
>> +             for (i = 0; i < len / 2 * 2; i += 2) {
>> +                     test = bf5xx_read(map, from + i);
>> +                     *((u16*)(to + i)) = test.x[0];
>                        ^^^^^^^^^^^^^^^^^
>
> I'm not particularly fond of such constructs, maybe because I have such
> a hard time understanding what the code actually does.
>
> How about:
>        u16 *foo = to;
>
>        for (i = 0; i < (len & ~1); i++) {
>                test = bf5xx_read(map, from + 2 * i);
>                foo[i] = test.x[0];
>        }
>
> With perhaps a better name than "foo" and the same conversion in the
> rest of the function as well?

indeed.  Bryan: i can take care of this as there's a few other pieces
i want to fiddle first (like getting rid of "bf5xx")
-mike
