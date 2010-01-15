Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab0AOBrR (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 20:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937Ab0AOBrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:47:15 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:58491 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab0AOBrP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:47:15 -0500
MIME-Version: 1.0
In-Reply-To: <4B4FB766.1020805@gmail.com>
References: <4B4FB766.1020805@gmail.com>
Date: Fri, 15 Jan 2010 09:47:14 +0800
Message-ID: <d3f22a1001141747p25b3406fv55364be65002546b@mail.gmail.com>
Subject: Re: [PATCH] ACPICA: wrong acpi_parse_state assigned 
	acpi_ps_init_scope() ?
From: Lin Ming <lin@minggr.cn>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 8:31 AM, Roel Kluin <roel.kluin@gmail.com> wrote:
> Assign the package end, not the last AML byte.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Is this right?
>
> diff --git a/drivers/acpi/acpica/psscope.c b/drivers/acpi/acpica/psscope.c
> index 2feca5c..a8dfe16 100644
> --- a/drivers/acpi/acpica/psscope.c
> +++ b/drivers/acpi/acpica/psscope.c
> @@ -118,7 +118,7 @@ acpi_ps_init_scope(struct acpi_parse_state * parser_state,
>        scope->parse_scope.op = root_op;
>        scope->parse_scope.arg_count = ACPI_VAR_ARGS;
>        scope->parse_scope.arg_end = parser_state->aml_end;
> -       scope->parse_scope.pkg_end = parser_state->aml_end;
> +       scope->parse_scope.pkg_end = parser_state->pkg_end;

->aml_end and ->pkg_end are same here.

acpi_ps_init_scope is only called in acpi_ds_init_aml_walk which set
aml_end and pkg_end the same.

acpi_ds_init_aml_walk(...)
{
    ....
    walk_state->parser_state.aml_end =
            walk_state->parser_state.pkg_end = aml_start + aml_length;
    .....

    status = acpi_ps_init_scope(&walk_state->parser_state, op);
    .....
}

Lin Ming

>
>        parser_state->scope = scope;
>        parser_state->start_op = root_op;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
