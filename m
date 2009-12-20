Return-Path: <linux-kernel-owner+w=401wt.eu-S1752523AbZLTJHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbZLTJHN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 04:07:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbZLTJHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 04:07:10 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:35668 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbZLTJHF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 04:07:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KVhDRWchgrtJR+aCCyGI4gm2FjYNE2d4Z1KpBLnXpbWKk204LSeInnsUzj0V6ttZgR
         EMqVA0OUUtFLn8KqpRwexgStU97H0Ll6VtgVIp1WPQz9OiNSuuovrMRXNuPiI1VA45Ih
         9LhJfrOzon75Fpv58QDqEhGq6wq+/uWvqKdWo=
MIME-Version: 1.0
In-Reply-To: <1261222401.435.6.camel@localhost>
References: <1261222401.435.6.camel@localhost>
Date: Sun, 20 Dec 2009 10:07:03 +0100
X-Google-Sender-Auth: 31f7208f363cc821
Message-ID: <10f740e80912200107v4ffeee81k77e291ffaebac837@mail.gmail.com>
Subject: Re: [uml-devel] linux-2.6.32 uml Segmentation fault
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: clownix <clownix@clownix.net>, David Howells <dhowells@redhat.com>,
       James Morris <jmorris@namei.org>, stable <stable@kernel.org>
Cc: uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       uml-user <user-mode-linux-user@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 19, 2009 at 12:33, clownix <clownix@clownix.net> wrote:
> Hello
> For the 2.6.32 kernel there are 2 problems:
>
> 1: Compile error, this patch works for it:
> --------------------------------------------
>
> diff -Naur old_linux-2.6.32.1/security/keys/keyctl.c
> linux-2.6.32.1/security/keys/keyctl.c
> --- old_linux-2.6.32.1/security/keys/keyctl.c   2009-12-14
> 18:47:25.000000000 +0100
> +++ linux-2.6.32.1/security/keys/keyctl.c       2009-12-15 22:40:32.565286766
> +0100
> @@ -1236,6 +1236,7 @@
>  */
>  long keyctl_session_to_parent(void)
>  {
> +#ifdef TIF_NOTIFY_RESUME
>        struct task_struct *me, *parent;
>        const struct cred *mycred, *pcred;
>        struct cred *cred, *oldcred;
> @@ -1326,6 +1327,9 @@
>  error_keyring:
>        key_ref_put(keyring_r);
>        return ret;
> +#else /* !TIF_NOTIFY_RESUME */
> +       return -EOPNOTSUPP;
> +#endif /* !TIF_NOTIFY_RESUME */
>  }

Aha, UML is also affected.

Commit a00ae4d21b2fa9379914f270ffffd8d3bec55430 ("Keys:
KEYCTL_SESSION_TO_PARENT needs TIF_NOTIFY_RESUME architecture
support") should be in 2.6.32-stable as it fixes a regression, but
apparently the `Cc: stable@kernel.org' got lost?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
