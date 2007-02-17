Return-Path: <linux-kernel-owner+w=401wt.eu-S1946394AbXBQDzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946394AbXBQDzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 22:55:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946395AbXBQDzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 22:55:17 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:26658 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946394AbXBQDzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 22:55:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=slOOgDUIzXWFcPkMNc1Cnx4hHX26IwzA5s6Rl59g6qyiV5bqH9wfnhfzwDov2jjcpd8Sq1WNbNUINt0x8TB/TJXzNiFpyTdhJp1B+v3gDBId6T2lQ+74xhlaKNPg6L3E23aeGM54Q6uFWBOTDhNpSmuCHolNShjRzwZILyP5A8o=
Message-ID: <d9def9db0702161955y1543e995o48b63eb1265e22a8@mail.gmail.com>
Date: Sat, 17 Feb 2007 04:55:12 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Eric Piel" <Eric.Piel@tremplin-utc.net>
Subject: Re: O2micro smartcard reader driver.
Cc: "Oliver Neukum" <oliver@neukum.org>, linux-kernel@vger.kernel.org
In-Reply-To: <d9def9db0702161536i64cf6fb3o1c3c8ff850c38994@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_13544_17598113.1171684512779"
References: <20061127182817.d52dfdf1.l.bigonville@edpnet.be>
	 <456C0BD0.7080606@tremplin-utc.net>
	 <200611281249.45243.oliver@neukum.org>
	 <457F1F0F.20109@tremplin-utc.net>
	 <d9def9db0702161536i64cf6fb3o1c3c8ff850c38994@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_13544_17598113.1171684512779
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Eric,

I committed your code to linuxtv.org to review and modify it there.
http://linuxtv.org/hg/~mrechberger/chipcardreader

one thing I noticed is the error handling in ozscr_probe.

I'll continue the rest during the next few days, I'd like to see it as
soon as possible in the upstream kernel before some kernel api changes
again which affects your current driver.

Markus

On 2/17/07, Markus Rechberger <mrechberger@gmail.com> wrote:
> Hi,
>
> so finally I'm also looking at that driver,
> http://pieleric.free.fr/o2scr/
> the driver compiles fine, though it doesn't seem to work (unless I'm
> doing something wrong here)
>
> dmesg shows up following entries:
>
> pccard: card ejected from slot 1
> PCMCIA: socket c160c364: *** DANGER *** unable to remove socket power
> pccard: PCMCIA card inserted into slot 1
> pcmcia: registering new device pcmcia1.0
> pccard: card ejected from slot 1
> PCMCIA: socket c160c364: *** DANGER *** unable to remove socket power
> pccard: PCMCIA card inserted into slot 1
> pcmcia: registering new device pcmcia1.0
> pccard: card ejected from slot 1
> PCMCIA: socket c160c364: *** DANGER *** unable to remove socket power
> pccard: PCMCIA card inserted into slot 1
> pcmcia: registering new device pcmcia1.0
> OZSCRLX O2Micro SmartCardBus Reader (for kernel >=3D 2.6.17)
>
> The module for any reason has a usecount value of 1
> ozscrlx                21548  1
>
> devicenode /dev/ozscrlx isn't opened anywhere either.
>
> I'll do some further investigations uppon it, I'd also like to see it
> directly in the kernel. It would be handy to use for encrypted
> filesystems.
>
> Markus
>
>
> On 12/12/06, Eric Piel <Eric.Piel@tremplin-utc.net> wrote:
> > 28.11.2006 12:49, Oliver Neukum wrote/a =E9crit:
> > >> Latest version I've published is there:
> > >> http://pieleric.free.fr/o2scr/
> > >
> > >         case OZSCR_OPEN: /* Request ICC */
> > >             dprintk("OZSCR_OPEN\n");
> > >             ATRLength =3D ATR_SIZE;
> > >             pRdrExt->IOBase =3D (PSCR_REGISTERS *) dev->io_base; //XX=
X
> > necessary?
> > >             pRdrExt->membase =3D dev->am_base; //XXX necessary?
> > >
> > >             pRdrExt->m_SCard.AvailableProtocol =3D 0;
> > >             pRdrExt->m_SCard.RqstProtocol =3D 0;
> > >             dprintk("membase:%p\n", pRdrExt->membase);
> > >             dprintk("ioport:0x%03x\n", (unsigned)pRdrExt->IOBase);
> > >
> > >             ret =3D CmdResetReader( pRdrExt, FALSE, ATRBuffer, &ATRLe=
ngth
> );
> > >             apdu.LengthOut =3D ATRLength;
> > >
> > > #ifdef PCMCIA_DEBUG
> > >             printk(KERN_DEBUG "Open finished, ATR buffer =3D ");
> > >             for( ATRLength =3D 0; ATRLength < apdu.LengthOut; ATRLeng=
th++
> )
> > >                 printk(" [%02X] ", ATRBuffer[ATRLength] );
> > >             printk("\n");
> > > #endif
> > >
> > >             memcpy( apdu.DataOut, ATRBuffer, ATRLength );
> > >             ret =3D copy_to_user((struct ozscr_apdu *)arg, &apdu,
> > sizeof(struct ozscr_apdu));
> > >             break;
> > >
> > > 1. This needs locking against concurrent ioctls
> > > 2. The interpretation of copy_to_user()'s return code is incorrect
> > >
> >
> > Hi Oliver,
> >
> > Thanks a lot for reading my code, I didn't even hope that someone would=
!
> > I've corrected the copy_to_user (and copy_from_user) code. However I
> > don't know how to do locking for the concurrent ioctls. Indeed, I don't
> > think there is anything preventing two programs to call the driver at
> > the same time. Unfortunately, I've got no idea how to do the locking an=
d
> > surprisingly couldn't find any ioctl code in the kernel doing locking.
> > Maybe I've just not looked at the right place, could you give a me some
> > hint how to do locking for ioctl's ?
> >
> > See you,
> > Eric
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
>
>
> --
> Markus Rechberger
>


--=20
Markus Rechberger

------=_Part_13544_17598113.1171684512779
Content-Type: text/x-diff; name="ozscr_probe.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="ozscr_probe.diff"
X-Attachment-Id: file0

LS0tIG96c2NybHguYy4xCTIwMDYtMTItMTIgMjI6Mjg6MjQuMDAwMDAwMDAwICswMTAwCisrKyBv
enNjcmx4LmMJMjAwNy0wMi0xNyAwMTowMDo0Ni4wMDAwMDAwMDAgKzAxMDAKQEAgLTU5NiwxNCAr
NTk2LDE0IEBACiAJZGV2ID0ga3phbGxvYyhzaXplb2Yoc3RydWN0IG96c2NyX2Rldl90KSwgR0ZQ
X0tFUk5FTCk7CiAJaWYgKGRldiA9PSBOVUxMKSB7CiAJCWRwcmludGsoImFsbG9jYXRlIG96c2Ny
X2Rldl90IGZhaWxcbiIpOwotCQlnb3RvIEVyckhhbmRsZTsKKwkJZ290byBFcnJIYW5kbGUxOwog
CX0KIAogCS8qIEFsbG9jYXRlIHNwYWNlIGZvciBwcml2YXRlIGRldmljZS1zcGVjaWZpYyBkYXRh
ICovCiAJZGV2LT5vMnNjcl9yZWFkZXIgPSBremFsbG9jKHNpemVvZihSRUFERVJfRVhURU5TSU9O
ICopLCBHRlBfS0VSTkVMKTsKIAlpZiAoZGV2LT5vMnNjcl9yZWFkZXIgPT0gTlVMTCkgewogCQlk
cHJpbnRrKCJhbGxvY2F0ZSBSRUFERVJfRVhURU5TSU9OIGZhaWxcbiIpOwotCQlnb3RvIEVyckhh
bmRsZTsKKwkJZ290byBFcnJIYW5kbGUyOwogCX0KIAogCXBfZGV2LT5wcml2ID0gZGV2OwpAQCAt
NjI4LDcgKzYyOCw3IEBACiAKIAlyZXQgPSBvenNjcl9jb25maWcocF9kZXYpOwogCWlmIChyZXQp
Ci0JCWdvdG8gRXJySGFuZGxlOworCQlnb3RvIEVyckhhbmRsZTM7CiAKIAkvLyBpdCdzIGp1c3Qg
c28gcmVkdW5kYW50Li4uIHdlIGNvdWxkIG1lcmdlIHRob3NlIGZpZWxkcyB0b2dldGhlcgogCWRl
di0+bzJzY3JfcmVhZGVyLT5JT0Jhc2UgPSAoUFNDUl9SRUdJU1RFUlMgKikgZGV2LT5pb19iYXNl
OwpAQCAtNjQ0LDExICs2NDQsMTEgQEAKIAlkcHJpbnRrKCJmdW5jdGlvbiBjb21wbGV0ZVxuIik7
CiAJcmV0dXJuIDA7CiAKLSAgICAgIEVyckhhbmRsZToKLQkvKiBGcmVlIHRoZSBhbGxvY2F0ZWQg
bWVtb3J5IHNwYWNlICovCi0JaWYgKGRldikKLQkJa2ZyZWUoZGV2LT5vMnNjcl9yZWFkZXIpOwor
ICAgICAgRXJySGFuZGxlMzoKKwlrZnJlZShkZXYtPm8yc2NyX3JlYWRlcik7CisgICAgICBFcnJI
YW5kbGUyOgogCWtmcmVlKGRldik7CisgICAgICBFcnJIYW5kbGUxOgogCXJldHVybiByZXQ7CiB9
CiAK
------=_Part_13544_17598113.1171684512779--
